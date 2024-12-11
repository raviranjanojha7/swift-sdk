//
//  PlaylistData.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//


struct PlaylistData: Codable, Identifiable {
    let id: String
    let media: [PlaylistMediaItem]
    let settings: QuinnSettings?
    let templates: Templates?
    let paginationInfo: [String: PlaylistPagination]?
    let nextPlaylistChunkId: String?
    let prevPlaylistChunkId: String?
}


struct PlaylistMediaItem: Codable {
    let type: PlaylistMediaType
    let group: PlaylistMediaGroup?
    let media: PlaylistMedia?
}

enum PlaylistMediaType: String, Codable {
    case media = "MEDIA"
    case group = "GROUP"
}

struct PlaylistMediaGroup: Codable, Identifiable {
    let id: String
    let hidden: Bool
    let sequence: Int
    let medias: [PlaylistMedia]
    let name: String
    let title: String?
    let subtitle: String?
    let templates: Templates?
}

struct PlaylistPagination: Codable, Identifiable {
    let id: String
    let playlistId: String
    let isSynced: Bool
    let nextPlaylistChunkId: String?
    let prevPlaylistChunkId: String?
}
