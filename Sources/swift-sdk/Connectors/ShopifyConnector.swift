//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation


class ShopifyConnector: BaseConnector {
    let shop: String
    let accessToken: String
    
    init(shop: String, accessToken: String) {
        self.shop = shop
        self.accessToken = accessToken
    }
    
    func getPlaylistData(playlistId: String) async throws -> PlaylistData {
        print("Starting getPlaylistData in ShopifyConnector")
        
        let urlString = "https://zany-calm-energy.glitch.me/data"
        print("URL being called: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            throw APIError.invalidURL
        }
        
        print("Before network call")
        do {
            let response = try await NetworkManager.shared.fetchData(from: url, as: PlaylistResponse.self)
            print("Network call completed successfully")
            print("Response data: \(response)")
            
            guard let playlistObj = try? JSONDecoder().decode(PlaylistData.self, from: Data(response.playlist.utf8)) else {
                print("Failed to decode playlist")
                throw APIError.invalidData
            }
            
            // Handle empty settings case
            let settingsObj: QuinnSettings
            if response.settings == "{}" {
                settingsObj = QuinnSettings() 
            } else {
                guard let decoded = try? JSONDecoder().decode(QuinnSettings.self, from: Data(response.settings.utf8)) else {
                    print("Failed to decode settings")
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
                            urls: getUrls(files: media.files, mediaId: media.id),
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
                                urls: getUrls(files: media.files, mediaId: media.id),
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
            
            print("Transformation completed")
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
    func getSettings() {}
    func getProductsData() {}
    func getPlaylistHandle() {}
    func getPaginatedPlaylistMetadata() {}
    func getPaginatedPlaylistMediaData() {}
    func getFilePrefix() {}
}
