//
//  File 2.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 12/12/24.
//

import Foundation

func getUrls(files: [MediaFile], mediaId: String) -> MediaUrls {
    var urls: [String: String] = [:]
    
    for file in files {
        let fileExtension = ["STORY", "POSTER"].contains(file.variant.rawValue) ? "jpg" : "mp4"
        urls[file.variant.rawValue] = "https://videocdn.quinn.live/\(mediaId)/quinn_\(file.id).\(fileExtension)"
    }
    
    return MediaUrls(
        short: urls["SHORT"],
        full: urls["FULL"],
        poster: urls["POSTER"],
        story: urls["STORY"]
    )
}

func getHandleHash(handle: String, shopType: String = "SHOPIFY") async throws -> String {
    if handle.hasPrefix("/") || shopType == "GENERAL" {
        return sha256(handle)
    } else {
        return handle
    }
}