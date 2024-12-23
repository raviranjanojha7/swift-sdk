//
//  File 3.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation

struct PlaylistResponse: Codable {
    let playlist: String
    let settings: String
    let templates: String
}


class GeneralConnector: BaseConnector {
    let shop: String
    let accessToken: String
    let cdn: String
    
    init(shop: String, accessToken: String, cdn: String) {
        self.shop = shop
        self.accessToken = accessToken
        self.cdn = cdn
    }
    
    func getPlaylistData(playlistId: String) async throws -> PlaylistDataWithProducts {
        let urlString = "https://zany-calm-energy.glitch.me/data-grouped"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let response = try await NetworkManager.shared.fetchData(from: url, as: PlaylistResponse.self)
            
            // Decode initial playlist without products
            guard let playlistObj = try? JSONDecoder().decode(PlaylistDataWithoutProducts.self, from: Data(response.playlist.utf8)) else {
                throw APIError.invalidData
            }
            
            // Handle empty settings case
            let settingsObj: QuinnSettings
            if response.settings == "{}" {
                settingsObj = QuinnSettings() 
            } else {
                guard let decoded = try? JSONDecoder().decode(QuinnSettings.self, from: Data(response.settings.utf8)) else {
                    throw APIError.invalidData
                }
                settingsObj = decoded
            }
            
            // Collect all media items for product fetching
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
            
            // Transform the media items (for now with empty products)
            let transformedMedia = playlistObj.media.map { mediaItem -> PlaylistMediaItem<PlaylistMedia<MediaProduct>> in
                switch mediaItem.type {
                case .media:
                    if let media = mediaItem.media {
                        let transformedMedia = PlaylistMedia<MediaProduct>(
                            id: media.id,
                            filename: media.filename,
                            products: [],  // Empty products for now
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
                        let transformedMedias = group.medias.map { media in
                            PlaylistMedia<MediaProduct>(
                                id: media.id,
                                filename: media.filename,
                                products: [],  // Empty products for now
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
            
            // Create new PlaylistData with transformed components
            return PlaylistData(
                id: playlistObj.id,
                media: transformedMedia,
                settings: settingsObj,
                templates: nil,
                paginationInfo: playlistObj.paginationInfo,
                nextPlaylistChunkId: playlistObj.nextPlaylistChunkId,
                prevPlaylistChunkId: playlistObj.prevPlaylistChunkId
            )
        } catch {
            print("Network or decoding error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func getProductsData(productIds: [String]) async throws -> ShopifyProductsResponse {
        // Create empty JSON string
        let emptyJson = "{\"data\":{}}"
        let emptyData = emptyJson.data(using: .utf8)!
        
        // Decode empty response
        let emptyResponse = try JSONDecoder().decode(ShopifyProductsResponse.self, from: emptyData)
        return emptyResponse
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



