//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation


public enum ShopType: String, Codable {
    case shopify = "SHOPIFY"
    case general = "GENERAL"
}

struct Connector {
    let shop: String
    let cdn: String
    let accessToken: String
    let shopType: ShopType
}

struct AppConfig {
    let sft: String?
    let cdn: String
    let shopDomain: String
    let shopType: ShopType
}

public protocol QuinnProtocol {
    var sft: String { get }
    var cdn: String { get }
    var shopDomain: String { get }
    var shopType: ShopType { get }
    var apiCache: [String: String] { get }
    var functions: DefaultQuinnFunctions { get }
    var currencySymbol: String { get }
    var settings: QuinnSettings { get }
    var appId: String { get }
    var pageType: String? { get }
    var pageId: String? { get }
    var pageHandle: String? { get }
    var overlayState: OverlayState? { get set }
    var overlayLoadStartTime: Double? { get }
    var overlayLoadEndTime: Double? { get }
    var overlayOpenTime: Double? { get }
    var overlayDuration: Double? { get }
    var overlayWidth: Double? { get }
    var overlayHeight: Double? { get }
    var disableGradient: Bool? { get }
    var videoResizeMode: VideoResizeMode? { get }
    var fontFamily: String? { get }
    var version: String { get }
    var styles: QuinnStyles? { get }
}

struct Quinn: QuinnProtocol, Codable, Identifiable {
    let id = UUID()
    let sft: String
    let cdn: String
    let shopDomain: String
    let shopType: ShopType
    let apiCache: [String: String]
    let functions: DefaultQuinnFunctions
    let currencySymbol: String
    let settings: QuinnSettings
    let appId: String
    let pageType: String?
    let pageId: String?
    let pageHandle: String?
    var overlayState: OverlayState?
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.sft = try container.decode(String.self, forKey: .sft)
        self.cdn = try container.decode(String.self, forKey: .cdn)
        self.shopDomain = try container.decode(String.self, forKey: .shopDomain)
        self.shopType = try container.decode(ShopType.self, forKey: .shopType)
        self.apiCache = try container.decode([String: String].self, forKey: .apiCache)
        self.functions = DefaultQuinnFunctions()
        self.currencySymbol = try container.decode(String.self, forKey: .currencySymbol)
        self.settings = try container.decode(QuinnSettings.self, forKey: .settings)
        self.appId = try container.decode(String.self, forKey: .appId)
        self.pageType = try container.decodeIfPresent(String.self, forKey: .pageType)
        self.pageId = try container.decodeIfPresent(String.self, forKey: .pageId)
        self.pageHandle = try container.decodeIfPresent(String.self, forKey: .pageHandle)
        self.overlayState = try container.decodeIfPresent(OverlayState.self, forKey: .overlayState)
        self.overlayLoadStartTime = try container.decodeIfPresent(Double.self, forKey: .overlayLoadStartTime)
        self.overlayLoadEndTime = try container.decodeIfPresent(Double.self, forKey: .overlayLoadEndTime)
        self.overlayOpenTime = try container.decodeIfPresent(Double.self, forKey: .overlayOpenTime)
        self.overlayDuration = try container.decodeIfPresent(Double.self, forKey: .overlayDuration)
        self.overlayWidth = try container.decodeIfPresent(Double.self, forKey: .overlayWidth)
        self.overlayHeight = try container.decodeIfPresent(Double.self, forKey: .overlayHeight)
        self.disableGradient = try container.decodeIfPresent(Bool.self, forKey: .disableGradient)
        self.videoResizeMode = try container.decodeIfPresent(VideoResizeMode.self, forKey: .videoResizeMode)
        self.fontFamily = try container.decodeIfPresent(String.self, forKey: .fontFamily)
        self.version = try container.decode(String.self, forKey: .version)
        self.styles = try container.decodeIfPresent(QuinnStyles.self, forKey: .styles)
    }
    
    init(
        sft: String,
        cdn: String,
        shopDomain: String,
        shopType: ShopType,
        apiCache: [String: String],
        functions: DefaultQuinnFunctions,
        currencySymbol: String,
        settings: QuinnSettings,
        appId: String,
        pageType: String?,
        pageId: String?,
        pageHandle: String?,
        overlayState: OverlayState?,
        overlayLoadStartTime: Double?,
        overlayLoadEndTime: Double?,
        overlayOpenTime: Double?,
        overlayDuration: Double?,
        overlayWidth: Double?,
        overlayHeight: Double?,
        disableGradient: Bool?,
        videoResizeMode: VideoResizeMode?,
        fontFamily: String?,
        version: String,
        styles: QuinnStyles?
    ) {
        self.sft = sft
        self.cdn = cdn
        self.shopDomain = shopDomain
        self.shopType = shopType
        self.apiCache = apiCache
        self.functions = functions
        self.currencySymbol = currencySymbol
        self.settings = settings
        self.appId = appId
        self.pageType = pageType
        self.pageId = pageId
        self.pageHandle = pageHandle
        self.overlayState = overlayState
        self.overlayLoadStartTime = overlayLoadStartTime
        self.overlayLoadEndTime = overlayLoadEndTime
        self.overlayOpenTime = overlayOpenTime
        self.overlayDuration = overlayDuration
        self.overlayWidth = overlayWidth
        self.overlayHeight = overlayHeight
        self.disableGradient = disableGradient
        self.videoResizeMode = videoResizeMode
        self.fontFamily = fontFamily
        self.version = version
        self.styles = styles
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sft, forKey: .sft)
        try container.encode(cdn, forKey: .cdn)
        try container.encode(shopDomain, forKey: .shopDomain)
        try container.encode(shopType, forKey: .shopType)
        try container.encode(apiCache, forKey: .apiCache)
        try container.encode(currencySymbol, forKey: .currencySymbol)
        try container.encode(settings, forKey: .settings)
        try container.encode(appId, forKey: .appId)
        try container.encodeIfPresent(pageType, forKey: .pageType)
        try container.encodeIfPresent(pageId, forKey: .pageId)
        try container.encodeIfPresent(pageHandle, forKey: .pageHandle)
        try container.encodeIfPresent(overlayState, forKey: .overlayState)
        try container.encodeIfPresent(overlayLoadStartTime, forKey: .overlayLoadStartTime)
        try container.encodeIfPresent(overlayLoadEndTime, forKey: .overlayLoadEndTime)
        try container.encodeIfPresent(overlayOpenTime, forKey: .overlayOpenTime)
        try container.encodeIfPresent(overlayDuration, forKey: .overlayDuration)
        try container.encodeIfPresent(overlayWidth, forKey: .overlayWidth)
        try container.encodeIfPresent(overlayHeight, forKey: .overlayHeight)
        try container.encodeIfPresent(disableGradient, forKey: .disableGradient)
        try container.encodeIfPresent(videoResizeMode, forKey: .videoResizeMode)
        try container.encodeIfPresent(fontFamily, forKey: .fontFamily)
        try container.encode(version, forKey: .version)
        try container.encodeIfPresent(styles, forKey: .styles)
    }
}

public enum VideoResizeMode: String, Codable {
    case contain
    case cover
}

public struct QuinnStyles: Codable {
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
    let variant: ProductVariant
    let mediaKey: String
}


public class DefaultQuinnFunctions: QuinnFunctions {
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

