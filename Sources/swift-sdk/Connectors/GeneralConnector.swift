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
    
    init(shop: String, accessToken: String) {
        self.shop = shop
        self.accessToken = accessToken
    }
    
    func getPlaylistData(handle: String, paginatedHash: String? = nil) async throws -> PlaylistData {
        let handleHash = try await getHandleHash(handle: handle, shopType: "GENERAL")
        
        let urlString = paginatedHash != nil
        ? "https://assets.quinn.live/\(paginatedHash!)"
        : "https://assets.quinn.live/\(shop)/\(handleHash).json"
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let response = try await NetworkManager.shared.fetchData(from: url, as: PlaylistResponse.self)
        
        guard let playlistObj = try? JSONDecoder().decode(PlaylistData.self, from: Data(response.playlist.utf8)),
              let settingsObj = try? JSONDecoder().decode(QuinnSettings.self, from: Data(response.settings.utf8)),
              let templatesObj = try? JSONDecoder().decode(Templates.self, from: Data(response.templates.utf8)) else {
            throw APIError.invalidData
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
        
        // Create new PlaylistData with all transformed components
        return PlaylistData(
            id: playlistObj.id,
            media: transformedMedia,
            settings: settingsObj,
            templates: templatesObj,
            paginationInfo: playlistObj.paginationInfo,
            nextPlaylistChunkId: playlistObj.nextPlaylistChunkId,
            prevPlaylistChunkId: playlistObj.prevPlaylistChunkId
        )
    }
    
    func getSettings() {}
    func getProductsData() {}
    func getPlaylistHandle() {}
    func getPaginatedPlaylistMetadata() {}
    func getPaginatedPlaylistMediaData() {}
    func getFilePrefix() {}
}



