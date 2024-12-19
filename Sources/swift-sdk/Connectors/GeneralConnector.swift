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
    
    func getPlaylistData(playlistId: String) async throws -> PlaylistData {
        
        let urlString = "https://zany-calm-energy.glitch.me/data-grouped"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let response = try await NetworkManager.shared.fetchData(from: url, as: PlaylistResponse.self)
                    
            guard let playlistObj = try? JSONDecoder().decode(PlaylistData.self, from: Data(response.playlist.utf8)) else {
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
            
            
            // Transform the playlist
            let transformedMedia = playlistObj.media.map { mediaItem -> PlaylistMediaItem in
                switch mediaItem.type {
                case .media:
                    if let media = mediaItem.media {
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
    
    func getProductsData(productIds: [String]) async throws -> [ProductData] {
        // Implementation for getting product data
        return []
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



