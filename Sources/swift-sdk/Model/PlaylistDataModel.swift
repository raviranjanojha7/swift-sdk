//
//  PlaylistData.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//


struct PlaylistData: Codable, Identifiable, Sendable {
    let id: String
    let media: [PlaylistMediaItem]
    let settings: QuinnSettings?
    let templates: Templates?
    let paginationInfo: [String: PlaylistPagination]?
    let nextPlaylistChunkId: String?
    let prevPlaylistChunkId: String?
}


struct PlaylistMediaItem: Codable, Sendable {
    let type: PlaylistMediaType
    let group: PlaylistMediaGroup?
    let media: PlaylistMedia?
}

enum PlaylistMediaType: String, Codable, Sendable {
    case media = "MEDIA"
    case group = "GROUP"
}

struct PlaylistMediaGroup: Codable, Identifiable, Sendable {
    let id: String
    let hidden: Bool
    let sequence: Int
    let medias: [PlaylistMedia]
    let name: String
    let title: String?
    let subtitle: String?
    let templates: Templates?
}

struct PlaylistPagination: Codable, Identifiable, Sendable {
    let id: String
    let playlistId: String
    let isSynced: Bool
    let nextPlaylistChunkId: String?
    let prevPlaylistChunkId: String?
}

extension PlaylistMediaItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(media?.id)
        hasher.combine(group?.id)
    }
    
    public static func == (lhs: PlaylistMediaItem, rhs: PlaylistMediaItem) -> Bool {
        return lhs.media?.id == rhs.media?.id && lhs.group?.id == rhs.group?.id
    }
}
