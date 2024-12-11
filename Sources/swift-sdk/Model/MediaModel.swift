//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation


struct PlaylistMedia: Codable, Identifiable {
    let id: String
    let filename: String
    let products: [ProductReference]
    let files: [MediaFile]
    let storytitle: String?
    let storysubtitle: String?
    let sequence: Int
    let urls: MediaUrls?
    let hidden: Bool
    let templates: Templates?
    let chunkId: String?
    let ctalink: String?
    let ctatitle: String?
}

struct ProductReference: Codable {
    let productid: String
    let handle: String
}

struct MediaFile: Codable {
    let mediaid: String
    let variant: MediaVariant
    let id: String
}

enum MediaVariant: String, Codable {
    case full = "FULL"
    case short = "SHORT"
    case poster = "POSTER"
    case story = "STORY"
}

struct MediaUrls: Codable {
    let short: String?
    let full: String?
    let poster: String?
    let story: String?
    
    enum CodingKeys: String, CodingKey {
        case short = "SHORT"
        case full = "FULL"
        case poster = "POSTER"
        case story = "STORY"
    }
}
