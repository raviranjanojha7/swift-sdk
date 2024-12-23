//
//  PlaylistData.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

typealias PlaylistDataWithProducts = PlaylistData<PlaylistMedia<MediaProduct>>
typealias PlaylistDataWithoutProducts = PlaylistData<PlaylistMedia<ProductReference>>

typealias PlaylistMediaItemWithProducts = PlaylistMediaItem<PlaylistMedia<MediaProduct>>
typealias PlaylistMediaItemWithoutProducts = PlaylistMediaItem<PlaylistMedia<ProductReference>>

typealias PlaylistMediaGroupWithProducts = PlaylistMediaGroup<PlaylistMedia<MediaProduct>>
typealias PlaylistMediaGroupWithoutProducts = PlaylistMediaGroup<PlaylistMedia<ProductReference>>

struct PlaylistData<T: Codable & Sendable>: Codable, Identifiable, Sendable {
    let id: String
    let media: [PlaylistMediaItem<T>]
    let settings: QuinnSettings?
    let templates: Templates?
    let paginationInfo: [String: PlaylistPagination]?
    let nextPlaylistChunkId: String?
    let prevPlaylistChunkId: String?
}



struct PlaylistMediaItem<T: Codable & Sendable>: Codable, Sendable {
    let type: PlaylistMediaType
    let group: PlaylistMediaGroup<T>?
    let media: T?
}

enum PlaylistMediaType: String, Codable, Sendable {
    case media = "MEDIA"
    case group = "GROUP"
}

struct PlaylistMediaGroup<T: Codable & Sendable>: Codable, Identifiable, Sendable {
    let id: String
    let hidden: Bool
    let sequence: Int
    let medias: [T]
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
