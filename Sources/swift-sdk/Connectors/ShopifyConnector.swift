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
    
    func getPlaylistData(playlistId: String) async throws -> PlaylistDataWithProducts {
        do {
            // Create GraphQL query
            let query = ShopifyGQLQueries.GET_META_OBJECT
            let variables = ["handle": ["handle": playlistId, "type": "app--\(APP_ID)--widgets"]]
            let requestBody = GraphQLRequestBody(query: query, variables: variables)
            
            // Make the request
            let response = try await graphQLService.query(requestBody) as MetaObjectResponse
            
            // Decode initial playlist data without products
            guard let playlistField = response.data.metaobject.fields.first(where: { $0.key == "playlist" }),
                  let playlistJson = playlistField.value,
                  let playlistObj = try? JSONDecoder().decode(PlaylistDataWithoutProducts.self, from: Data(playlistJson.utf8)) else {
                throw APIError.cannotParse
            }
            
            // Collect all media items (both individual and from groups)
            var allMedia: [PlaylistMedia<ProductReference>] = []
            playlistObj.media.forEach { mediaItem in
                switch mediaItem.type {
                case .media:
                    if let media = mediaItem.media {
                        allMedia.append(media)
                    }
                case .group:
                    if let group = mediaItem.group {
                        allMedia.append(contentsOf: group.medias)
                    }
                }
            }
            
            
            // Get product map using the new function
            let productMap = try await getMediaProductsDataMap(media: allMedia)
            
            
            // Transform the media items with product details
            let transformedMedia = playlistObj.media.map { mediaItem -> PlaylistMediaItem<PlaylistMedia<MediaProduct>> in
                switch mediaItem.type {
                case .media:
                    if let media = mediaItem.media {
                        // Map products to full product details
                        let updatedProducts = media.products.compactMap { product in
                            productMap[product.productid]
                        }
                        
                        let transformedMedia = PlaylistMedia<MediaProduct>(
                            id: media.id,
                            filename: media.filename,
                            products: updatedProducts,
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
                    return PlaylistMediaItem(type: mediaItem.type, group: nil, media: nil)
                    
                case .group:
                    if let group = mediaItem.group {
                        // Transform each media in the group with product details
                        let transformedMedias = group.medias.map { media in
                            // Map products to full product details
                            let updatedProducts = media.products.compactMap { product in
                                productMap[product.productid]
                            }
                            
                            return PlaylistMedia<MediaProduct>(
                                id: media.id,
                                filename: media.filename,
                                products: updatedProducts,
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
                    return PlaylistMediaItem(type: mediaItem.type, group: nil, media: nil)
                }
            }
            
            // Create new PlaylistData with all transformed components
            return PlaylistData(
                id: playlistObj.id,
                media: transformedMedia,
                settings: playlistObj.settings,
                templates: playlistObj.templates,
                paginationInfo: playlistObj.paginationInfo,
                nextPlaylistChunkId: playlistObj.nextPlaylistChunkId,
                prevPlaylistChunkId: playlistObj.prevPlaylistChunkId
            )
            
        } catch {
            print("Error fetching playlist data:", error)
            throw error
        }
    }
    
    func getProductsData(productIds: [String]) async throws -> ShopifyProductsResponse {
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
            
            
            return response
            
        } catch {
            print("Error fetching products data:", error)
            throw error
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
    
    func getMediaProductsDataMap(media: [PlaylistMedia<ProductReference>]) async throws -> [String: MediaProduct] {
        // Collect all product IDs
        var productIds: [String] = []
        
        media.forEach { media in
            if let products = media.products as? [ProductReference] {
                products.forEach { product in
                    productIds.append(product.productid)
                }
            }
        }
        
        // Fetch product data
        let response = try await getProductsData(productIds: productIds)
        
        // Create a map of product ID to MediaProduct
        var productMap: [String: MediaProduct] = [:]
        
        // Iterate through the response.data dictionary
        for (_, shopifyProduct) in response.data {
            // Remove non-numeric characters from ID to match TypeScript implementation
            let cleanId = shopifyProduct.id.replacingOccurrences(of: "[^0-9]",
                                                                 with: "",
                                                                 options: .regularExpression)
            
            // Convert ShopifyProduct to MediaProduct
            let mediaProduct = try convertToMediaProduct(shopifyProduct)
            
            productMap[cleanId] = mediaProduct
        }
        
        return productMap
    }
    
    // Helper function to convert ShopifyProduct to MediaProduct
    private func convertToMediaProduct(_ shopifyProduct: ShopifyProduct) throws -> MediaProduct {
        // Convert variants to SwatchData if variants exist
        let swatchesData: [String: SwatchData] = [:] // Default empty dictionary
        let swatchesDataFormatted: [String: [SwatchData]] = [:] // Default empty dictionary
        let productVariants: [ProductVariant] = [] // Default empty array
        
        // Create dictionary for card_top_labels
        let cardTopLabels: [String: Any] = [:]
        
        // Format images to match MediaProduct structure
        let formattedImages = shopifyProduct.images.nodes.map { node -> [String: String] in
            return [
                "url": node.url,
                "altText": node.altText ?? ""  // Add altText with empty string as default
            ]
        }
        
        
        // Create the MediaProduct using decoder with optional handling
        let productDict: [String: Any] = [
            "available": shopifyProduct.availableForSale ?? false,
            "card_top_labels": cardTopLabels,
            "compare_at_price": shopifyProduct.compareAtPriceRange?.minVariantPrice.amount ?? "0.0",
            "compare_at_price_max": shopifyProduct.compareAtPriceRange?.maxVariantPrice?.amount ?? "0.0",
            "compare_at_price_max_number": shopifyProduct.compareAtPriceRange?.maxVariantPrice?.amount ?? "0.0",
            "compare_at_price_min": shopifyProduct.compareAtPriceRange?.minVariantPrice.amount ?? "0.0",
            "compare_at_price_min_number": shopifyProduct.compareAtPriceRange?.minVariantPrice.amount ?? "0.0",
            "compare_at_price_number": shopifyProduct.compareAtPriceRange?.minVariantPrice.amount ?? "0.0",
            "description": shopifyProduct.description,
            "featured_image": shopifyProduct.featuredImage?.image_large ?? "",
            "featured_image_large": shopifyProduct.featuredImage?.image_large ?? "",
            "handle": shopifyProduct.handle,
            "id": shopifyProduct.id,
            "images": formattedImages,
            "options": shopifyProduct.options?.map { $0.name } ?? [],
            "options_with_values": shopifyProduct.options?.map { [
                "id": $0.id,
                "name": $0.name,
                "values": $0.values
            ] } ?? [],
            "price": shopifyProduct.priceRange.minVariantPrice.amount,
            "price_max": shopifyProduct.priceRange.maxVariantPrice?.amount ?? shopifyProduct.priceRange.minVariantPrice.amount,
            "price_max_number": shopifyProduct.priceRange.maxVariantPrice?.amount ?? shopifyProduct.priceRange.minVariantPrice.amount,
            "price_min": shopifyProduct.priceRange.minVariantPrice.amount,
            "price_min_number": shopifyProduct.priceRange.minVariantPrice.amount,
            "price_number": shopifyProduct.priceRange.minVariantPrice.amount,
            "productmetadata": [],
            "quinn_description": shopifyProduct.quinn_description?.value ?? "",
            "swatches_data": swatchesData,
            "swatches_data_formatted": swatchesDataFormatted,
            "title": shopifyProduct.title,
            "url": shopifyProduct.onlineStoreUrl ?? "",
             "variants": productVariants
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: productDict)
        
        do {
            return try JSONDecoder().decode(MediaProduct.self, from: jsonData)
        } catch {
            print("Decoding error: \(error)")
            throw error
        }
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
            title
                        description
                        id
                        compareAtPriceRange {
                            maxVariantPrice {
                                amount
                                currencyCode
                            }
                            minVariantPrice {
                                amount
                                currencyCode
                            }
                        }
                        description
                        featuredImage {
                            image_small: url(transform: { maxHeight: 200, maxWidth: 200 })
                            image_large: url
                        }
                        handle
                        id
                        options(first: 20) {
                            id
                            values
                            name
                        }
                        priceRange {
                            maxVariantPrice {
                                amount
                                currencyCode
                            }
                            minVariantPrice {
                                amount
                                currencyCode
                            }
                        }
                        tags
                        title
                        variants(first: 100) {
                            nodes {
                                id
                                image {
                                    url
                                }
                                selectedOptions {
                                    name
                                    value
                                }
                                sku
                                title
                                price {
                                    amount
                                    currencyCode
                                }
                                currentlyNotInStock
                                availableForSale
                                compareAtPrice {
                                    amount
                                    currencyCode
                                }
                                group: metafield(namespace: "color", key: "group") {
                                    value
                                }
                            }
                        }
                        images(first: 25) {
                            nodes {
                                url
                                altText
                            }
                        }
                        availableForSale
                        onlineStoreUrl
                        quinn_description: metafield(namespace: "quinn", key: "description") {
                            value
                        }
        }
    }
    """
}
