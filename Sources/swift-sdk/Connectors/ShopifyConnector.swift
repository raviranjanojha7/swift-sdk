//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation


class ShopifyConnector: BaseConnector {
    private let APP_ID = "5905719"
    let shop: String
    let accessToken: String
    let cdn: String
    private let graphQLService: GraphQLService
    
    init(shop: String, accessToken: String, cdn: String) {
        self.shop = shop
        self.accessToken = accessToken
        self.cdn = cdn
        self.graphQLService = GraphQLService(shop: shop, accessToken: accessToken)
    }
    
    func getPlaylistData(playlistId: String) async throws -> PlaylistData {
        do {
            // Create GraphQL query
            let query = ShopifyGQLQueries.GET_META_OBJECT
            let variables = ["handle": ["handle": playlistId, "type": "app--\(APP_ID)--widgets"]]
            
            let requestBody = GraphQLRequestBody(query: query, variables: variables)
            
            
            // Make the request
            let response = try await graphQLService.query(requestBody) as MetaObjectResponse
            
            // Find playlist data from fields
            guard let playlistField = response.data.metaobject.fields.first(where: { $0.key == "playlist" }),
                  let playlistJson = playlistField.value,
                  let playlistObj = try? JSONDecoder().decode(PlaylistData.self, from: Data(playlistJson.utf8)) else {
                throw APIError.invalidData
            }
            
            // Transform the playlist
            let transformedMedia = playlistObj.media.map { mediaItem -> PlaylistMediaItem in
                print("Media item type: \(mediaItem.type)")
                switch mediaItem.type {
                case .media:
                    if let media = mediaItem.media {
                        print("Media products:", media.products)
                        // Create new media with updated URLs
                        let transformedMedia = PlaylistMedia(
                            id: media.id,
                            filename: media.filename,
                            products: media.products,
                            files: media.files,
                            storytitle: media.storytitle,
                            storysubtitle: media.storysubtitle,
                            sequence: media.sequence,
                            urls: getUrls(files: media.files, mediaId: media.id, cdn: cdn),
                            hidden: media.hidden,
                            templates: media.templates,
                            chunkId: media.chunkId,
                            ctalink: media.ctalink,
                            ctatitle: media.ctatitle
                        )
                        
                        return PlaylistMediaItem(
                            type: mediaItem.type,
                            group: nil,
                            media: transformedMedia
                        )
                    }
                    return mediaItem
                    
                case .group:
                    if let group = mediaItem.group {
                        // Transform each media in the group
                        let transformedMedias = group.medias.map { media in
                            PlaylistMedia(
                                id: media.id,
                                filename: media.filename,
                                products: media.products,
                                files: media.files,
                                storytitle: media.storytitle,
                                storysubtitle: media.storysubtitle,
                                sequence: media.sequence,
                                urls: getUrls(files: media.files, mediaId: media.id, cdn: cdn),
                                hidden: media.hidden,
                                templates: media.templates,
                                chunkId: media.chunkId,
                                ctalink: media.ctalink,
                                ctatitle: media.ctatitle
                            )
                        }
                        
                        // Add this block to print products after transformation
                        transformedMedias.forEach { media in
                            print("Transformed group media products:", media.products)
                        }
                        
                        // Create new group with transformed medias
                        let transformedGroup = PlaylistMediaGroup(
                            id: group.id,
                            hidden: group.hidden,
                            sequence: group.sequence,
                            medias: transformedMedias,
                            name: group.name,
                            title: group.title,
                            subtitle: group.subtitle,
                            templates: group.templates
                        )
                        
                        return PlaylistMediaItem(
                            type: mediaItem.type,
                            group: transformedGroup,
                            media: nil
                        )
                    }
                    return mediaItem
                }
            }
            
            // Create new PlaylistData with all transformed components
            return PlaylistData(
                id: playlistObj.id,
                media: transformedMedia,
                settings: QuinnSettings(), // Using default settings since they're not in the GraphQL response
                templates: nil,
                paginationInfo: playlistObj.paginationInfo,
                nextPlaylistChunkId: playlistObj.nextPlaylistChunkId,
                prevPlaylistChunkId: playlistObj.prevPlaylistChunkId
            )
            
        } catch {
            print("Error fetching playlist data:", error)
            throw error
        }
    }
    
    func getProductsData(productIds: [String]) async throws -> [ProductData] {
        do {
            // Transform product IDs to Shopify format
            let shopifyProductIds = productIds.map { "gid://shopify/Product/\($0.replacingOccurrences(of: "\\D", with: "", options: .regularExpression))" }
            
            // Build dynamic query
            var queryBuilder = "query getMultipleProductById {"
            for (index, id) in shopifyProductIds.enumerated() {
                queryBuilder += "product\(index): \(ShopifyGQLQueries.EACH_PRODUCT_DETAILS.replacingOccurrences(of: "$id", with: "\"\(id)\"")), "
            }
            queryBuilder += "}"
            
            let requestBody = GraphQLRequestBody(query: queryBuilder, variables: [:])
            
            // Make the request
            let response: ShopifyProductsResponse = try await graphQLService.query(requestBody)
            
            // Transform response to ProductData array
            // Implementation depends on your ProductData model
            return []
            
        } catch {
            print("Error fetching products data:", error)
            return []
        }
    }
    
    func getSettings() {
        // Implementation for getting settings
    }
    
    func getPlaylistHandle() {
        // Implementation for getting playlist handle
    }
    
    func getPaginatedPlaylistMetadata() {
        // Implementation for getting paginated playlist metadata
    }
    
    func getPaginatedPlaylistMediaData() {
        // Implementation for getting paginated playlist media data
    }
    
    func getFilePrefix() {
        // Implementation for getting file prefix
    }
}

// GraphQL Queries
enum ShopifyGQLQueries {
    static let GET_META_OBJECT = """
    query getMetaObjectByHandle($handle: MetaobjectHandleInput!) {
      metaobject(handle: $handle) {
        fields {
          key
          value
        }
      }
    }
    """
    
    static let EACH_PRODUCT_DETAILS = """
    node(id: $id) {
      ... on Product {
        id
        title
        handle
        description
        priceRange {
          minVariantPrice {
            amount
            currencyCode
          }
        }
        images(first: 1) {
          edges {
            node {
              url
            }
          }
        }
      }
    }
    """
}
