//
//  File 3.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation


struct OverlayState: Codable {
    let activeIndex: Int?
    let playlist: PlaylistData?
    let medias: [String: OverlayMedia]?
    let media: OverlayMedia?
    let group: PlaylistMediaGroup?
    let groupMediaIndex: Int?
    let product: MediaProduct?
    let variant: Variant?
    let templates: Templates?
    let widgetType: WidgetType?
    let isMuted: Bool?
    let cart: ShopifyCart?
    let quantity: Int?
    let showCartTooltip: Bool?
    let lastSwipedAt: Double?
    let overlayOpenedAt: Double?
    let mediaProducts: [String: [MediaProduct]]?
    
    static let `default` = OverlayState(
            activeIndex: nil,
            playlist: nil,
            medias: [:],
            media: nil,
            group: nil,
            groupMediaIndex: nil,
            product: nil,
            variant: nil,
            templates: nil,
            widgetType: .cards, 
            isMuted: false,
            cart: nil,
            quantity: 0,
            showCartTooltip: false,
            lastSwipedAt: nil,
            overlayOpenedAt: nil,
            mediaProducts: [:]
        )
}

enum WidgetType: String, Codable {
    case cards
    case story
    case floating
    case overlay
    case vflp
    case feed
    case imax
}


enum OverlayEvents: String, Codable {
    case INDEX_CHANGE = "overlay:index_change"
    case OVERLAY_INFO_TOGGLE = "overlay:info_toggle"
    case OVERLAY_TOGGLE_VIDEO_SOUND = "overlay:toggle_video_sound"
    case OVERLAY_ADD_TO_CART = "overlay:add_to_cart"
    case OVERLAY_FOCUS_TOGGLE = "overlay:focus_toggle"
    case OVERLAY_CHANGE_INDEX = "overlay:change_index"
    case OVERLAY_GROUP_CHANGE_INDEX = "overlay:group_change_index"
}

struct ShopifyCart: Codable {
    let itemCount: Int
    let items: [ShopifyCartItem]
    let note: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case itemCount = "item_count"
        case items, note, token
    }
}

struct ShopifyCartItem: Codable, Identifiable {
    let id: String
    let title: String
    let url: String
    let handle: String
}

struct OverlayMedia: Codable, Identifiable {
    let id: String
    let filename: String
    let products: [MediaProduct]
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
    let properties: [String: String]?
}

struct OverlayMediaGroup: Codable, Identifiable {
    let id: String
    let hidden: Bool
    let sequence: Int
    let medias: [OverlayMedia]
    let name: String
    let title: String?
    let subtitle: String?
    let templates: Templates?
}

struct OverlayMediaItem: Codable {
    let type: PlaylistMediaType
    let group: OverlayMediaGroup?
    let media: OverlayMedia?
}
