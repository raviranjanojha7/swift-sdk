//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation


enum ShopType: String, Codable {
    case shopify = "SHOPIFY"
    case general = "GENERAL"
}

struct Connector {
    let shop: String
    let accessToken: String
    let shopType: ShopType
}

struct AppConfig {
    let sft: String?
    let cdn: String
    let shopDomain: String
    let shopType: ShopType
}

struct Quinn: Codable, Identifiable {
    let id = UUID()
    let sft: String
    let cdn: String
    let shopDomain: String
    let shopType: ShopType
    let apiCache: [String: String]
    let functions: QuinnFunctions
    let currencySymbol: String
    let settings: QuinnSettings
    let appId: String
    let pageType: String?
    let pageId: String?
    let pageHandle: String?
    let overlayState: OverlayState
    let overlayLoadStartTime: Double?
    let overlayLoadEndTime: Double?
    let overlayOpenTime: Double?
    let overlayDuration: Double?
    let overlayWidth: Double?
    let overlayHeight: Double?
    let disableGradient: Bool?
    let videoResizeMode: VideoResizeMode?
    let fontFamily: String?
    let version: String
    let styles: QuinnStyles?
    
    enum CodingKeys: String, CodingKey {
        case sft, cdn
        case shopDomain = "shop_domain"
        case shopType = "shop_type"
        case apiCache = "api_cache"
        case functions
        case currencySymbol = "currency_symbol"
        case settings
        case appId = "app_id"
        case pageType = "page_type"
        case pageId = "page_id"
        case pageHandle = "page_handle"
        case overlayState
        case overlayLoadStartTime, overlayLoadEndTime
        case overlayOpenTime, overlayDuration
        case overlayWidth, overlayHeight
        case disableGradient
        case videoResizeMode
        case fontFamily
        case version
        case styles
    }
}

enum VideoResizeMode: String, Codable {
    case contain
    case cover
}

struct QuinnStyles: Codable {
    let sizeSelector: SizeSelectorStyle?
    
    enum CodingKeys: String, CodingKey {
        case sizeSelector = "size_selector"
    }
}

struct SizeSelectorStyle: Codable {
    let selectedBgColor: String
    let selectedTextColor: String
    let bgColor: String
    let textColor: String
    
    enum CodingKeys: String, CodingKey {
        case selectedBgColor = "selected_bg_color"
        case selectedTextColor = "selected_text_color"
        case bgColor = "bg_color"
        case textColor = "text_color"
    }
}


struct Promise<T> {
    let then: (@escaping (T) -> Void) -> Void
}


protocol QuinnFunctions {
    func shareProduct(message: String, url: String)
    func parseReviews(reviewData: [String: Any]) -> ReviewsPayload
    func getReviews(product: [String: Any], page: Int, limit: Int?, apiKey: String?) async throws -> [String: Any]
    func openOverlay(payload: OpenOverlayAction)
    func closeOverlay()
    func setupOverlay(payload: SetupOverlay)
    func redirectToProduct(product: MediaProduct)
    func overlayInfoToggle(mediaKey: String)
    func addToCart(payload: AddToCart) async throws -> ShopifyCart?
    func openCartDrawer()
    func updateAppCart(cart: ShopifyCart?) async throws -> ShopifyCart?
    func showFullPageLoader()
    func hideFullPageLoader()
    func hideElements()
    func unhideElements()
    func redirectToPage(pageId: String)
    func getProductsById(ids: [String]) async throws -> [StorefrontProduct?]
}

struct ReviewsPayload {
    let reviews: [Any]
    let reviewCount: Int
    let avgRating: Double
}

struct OpenOverlayAction {
    let initialIndex: Int
    let handle: String?
    let widgetType: WidgetType
    let playlistId: String?
    let onClose: (() -> Void)?
    let chunkId: String?
}

struct SetupOverlay {
    let playlist: PlaylistData
    let index: Int
    let type: WidgetType
    let onClose: () -> Void
}

struct AddToCart {
    let product: MediaProduct
    let variant: Variant
    let mediaKey: String
}


class DefaultQuinnFunctions: QuinnFunctions {
    func shareProduct(message: String, url: String) {
    }
    
    func parseReviews(reviewData: [String: Any]) -> ReviewsPayload {
        return ReviewsPayload(reviews: [], reviewCount: 0, avgRating: 0.0)
    }
    
    func getReviews(product: [String: Any], page: Int, limit: Int? = nil, apiKey: String? = nil) async throws -> [String: Any] {
        return [:]
    }
    
    func openOverlay(payload: OpenOverlayAction) {
    }
    
    func closeOverlay() {
    }
    
    func setupOverlay(payload: SetupOverlay) {
    }
    
    func redirectToProduct(product: MediaProduct) {
    }
    
    func overlayInfoToggle(mediaKey: String) {
    }
    
    func addToCart(payload: AddToCart) async throws -> ShopifyCart? {
        return nil
    }
    
    func openCartDrawer() {
    }
    
    func updateAppCart(cart: ShopifyCart? = nil) async throws -> ShopifyCart? {
        return nil
    }
    
    func showFullPageLoader() {
    }
    
    func hideFullPageLoader() {
    }
    
    func hideElements() {
    }
    
    func unhideElements() {
    }
    
    func redirectToPage(pageId: String) {
    }
    
    func getProductsById(ids: [String]) async throws -> [StorefrontProduct?] {
        return []
    }
}

