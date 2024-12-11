//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 09/12/24.
//

import Foundation

struct QuinnSettings: Codable {
    let abControlGroupPercentage: String
    let abEnabledForWidgets: [String] // Changed from any[] to [String] - adjust type if needed
    let abEnabledOnPages: [String] // Changed from any[] to [String] - adjust type if needed
    let abTesting: Bool
    let abTestingId: String
    let calcNetSpeed: Bool
    let cartTracking: Bool
    let enableGif: Bool?
    let enableInterceptor: Bool
    let showAbTestingAnalytics: Bool
    let subscription: String
    let setupCompleted: Bool
    let onboarding: [String: String] //Any
    let forcedDisabled: Bool
    let cards: CardSettings
    let floating: FloatingSettings
    let general: GeneralSettings
    let overlay: OverlaySettings
    let events: [String]
    let customiser: CustomiserSettings
    let story: StorySettings
    let pallet: [String: String]
    let viewThresholdMiliseconds: Int
    
    enum CodingKeys: String, CodingKey {
        case abControlGroupPercentage = "ab_control_group_percentage"
        case abEnabledForWidgets = "ab_enabled_for_widgets"
        case abEnabledOnPages = "ab_enabled_on_pages"
        case abTesting = "ab_testing"
        case abTestingId = "ab_testing_id"
        case calcNetSpeed = "calc_net_speed"
        case cartTracking = "cart_tracking"
        case enableGif = "enable_gif"
        case enableInterceptor = "enable_interceptor"
        case showAbTestingAnalytics = "show_ab_testing_analytics"
        case subscription
        case setupCompleted
        case onboarding
        case forcedDisabled = "forced_disabled"
        case cards
        case floating
        case general
        case overlay
        case events
        case customiser
        case story
        case pallet
        case viewThresholdMiliseconds = "view_threshold_miliseconds"
    }
    
    
    static let `default` = QuinnSettings(
        abControlGroupPercentage: "50",
        abEnabledForWidgets: [],
        abEnabledOnPages: [],
        abTesting: false,
        abTestingId: "test01",
        calcNetSpeed: false,
        cartTracking: false,
        enableGif: false,
        enableInterceptor: false,
        showAbTestingAnalytics: false,
        subscription: "FREE",
        setupCompleted: true,
        onboarding: [
            "signupCompleted": "true",
            "subscribed": "true"
        ],
        forcedDisabled: false,
        cards: CardSettings.default,
        floating: FloatingSettings.default,
        general: GeneralSettings.default,
        overlay: OverlaySettings.default,
        events: [],
        customiser: CustomiserSettings.default,
        story: StorySettings.default,
        pallet: [
            "--quinn-card-title-color": "#000000",
            "--quinn-card-regular-price-color": "#000000",
            "--quinn-card-cut-off-price-color": "#000000",
            "--quinn-card-background-color": "#fff",
            "--quinn-primary-color": "#000",
            "--quinn-primary-text-color": "#fff",
            "--quinn-primary-border-color": "#000",
            "--quinn-secondary-color": "#FED716",
            "--quinn-secondary-text-color": "#000",
            "--quinn-tertiary-color": "#fff",
            "--quinn-tertiary-text-color": "#000",
            "--quinn-tertiary-border-color": "#DEDEDE",
            "--quinn-secondary-border-color": "#FED716"
        ],
        viewThresholdMiliseconds: 0
    )
}

// Supporting Models
struct VisibilitySettings: Codable {
    enum Visibility: String, Codable {
        case both, mobile, desktop
    }
    
    let visibility: Visibility
}

struct StorySettings: Codable {
    let heroText: String
    let heroTextColor: String
    let heroTitle: String
    let isSticky: Bool
    let showHeroStory: Bool
    let topOffsetOnCollectionDesktop: String
    let topOffsetOnCollectionMobile: String
    let topOffsetOnHomeDesktop: String
    let topOffsetOnHomeMobile: String
    let topOffsetOnProductDesktop: String
    let topOffsetOnProductMobile: String
    let visibility: VisibilitySettings.Visibility
    let websiteHeaderIdentifier: String
    
    enum CodingKeys: String, CodingKey {
        case heroText = "hero_text"
        case heroTextColor = "hero_text_color"
        case heroTitle = "hero_title"
        case isSticky = "is_sticky"
        case showHeroStory = "show_hero_story"
        case topOffsetOnCollectionDesktop = "top_offset_on_collection_desktop"
        case topOffsetOnCollectionMobile = "top_offset_on_collection_mobile"
        case topOffsetOnHomeDesktop = "top_offset_on_home_desktop"
        case topOffsetOnHomeMobile = "top_offset_on_home_mobile"
        case topOffsetOnProductDesktop = "top_offset_on_product_desktop"
        case topOffsetOnProductMobile = "top_offset_on_product_mobile"
        case visibility
        case websiteHeaderIdentifier = "website_header_identifier"
    }
    
    static let `default` = StorySettings(
        heroText: "WATCH & BUY!",
        heroTextColor: "#ffffff",
        heroTitle: "Bestsellers",
        isSticky: false,
        showHeroStory: true,
        topOffsetOnCollectionDesktop: "0",
        topOffsetOnCollectionMobile: "0",
        topOffsetOnHomeDesktop: "0",
        topOffsetOnHomeMobile: "0",
        topOffsetOnProductDesktop: "0",
        topOffsetOnProductMobile: "0",
        visibility: .both,
        websiteHeaderIdentifier: "#shopify-section-header"
    )
}

struct CardSettings: Codable {
    let cardsHeading: String
    let reviewsPlaceholder: String
    let showFirstProductPrice: Bool
    let visibility: VisibilitySettings.Visibility
    let useVariantPrice: Bool?
    
    enum CodingKeys: String, CodingKey {
        case cardsHeading = "cards_heading"
        case reviewsPlaceholder
        case showFirstProductPrice = "show_first_product_price"
        case visibility
        case useVariantPrice = "use_variant_price"
    }
    
    static let `default` = CardSettings(
        cardsHeading: "",
        reviewsPlaceholder: "New Arrival",
        showFirstProductPrice: false,
        visibility: VisibilitySettings.Visibility.both,
        useVariantPrice: false
    )
}

struct FloatingSettings: Codable {
    let desktopFloatingBottom: String
    let desktopFloatingRight: String
    let disableWidget: Bool
    let floatingSide: FloatingSide
    let floatingType: FloatingType
    let floatingZindex: String
    let mobileFloatingBottom: String
    let mobileFloatingRight: String
    
    enum FloatingSide: String, Codable {
        case left, right
    }
    
    enum FloatingType: String, Codable {
        case regular, circle, rectangle
    }
    
    enum CodingKeys: String, CodingKey {
        case desktopFloatingBottom = "desktop_floating_bottom"
        case desktopFloatingRight = "desktop_floating_right"
        case disableWidget = "disable_widget"
        case floatingSide = "floating_side"
        case floatingType = "floating_type"
        case floatingZindex = "floating_zindex"
        case mobileFloatingBottom = "mobile_floating_bottom"
        case mobileFloatingRight = "mobile_floating_right"
    }
    
    static let `default` = FloatingSettings(
        desktopFloatingBottom: "20",
        desktopFloatingRight: "20",
        disableWidget: false,
        floatingSide: .right,
        floatingType: .circle,
        floatingZindex: "9999",
        mobileFloatingBottom: "20",
        mobileFloatingRight: "20"
    )
}

struct GeneralSettings: Codable {
    let brandingTextColor: String
    let cartProvider: String
    let cartTagging: Bool
    let currencySymbol: String
    let overlayBrandingTextColor: String
    let reviewProvider: String
    let shouldLoopOverlay: Bool
    let showBranding: Bool
    let showOverlayBranding: Bool
    let showVideoWatermark: Bool
    let videoWatermarkTextColor: String
    let openCartDrawerOnAddToCart: Bool
    let preventPriceRound: Bool
    let swapCurrencySymbol: Bool
    let storeOffers: String
    let enableQuinnCdn: Bool
    
    enum CodingKeys: String, CodingKey {
        case brandingTextColor = "branding_text_color"
        case cartProvider = "cart_provider"
        case cartTagging = "cart_tagging"
        case currencySymbol = "currency_symbol"
        case overlayBrandingTextColor = "overlay_branding_text_color"
        case reviewProvider = "review_provider"
        case shouldLoopOverlay = "should_loop_overlay"
        case showBranding = "show_branding"
        case showOverlayBranding = "show_overlay_branding"
        case showVideoWatermark = "show_video_watermark"
        case videoWatermarkTextColor = "video_watermark_text_color"
        case openCartDrawerOnAddToCart = "open_cart_drawer_on_add_to_cart"
        case preventPriceRound = "prevent_price_round"
        case swapCurrencySymbol = "swap_currency_symbol"
        case storeOffers = "store_offers"
        case enableQuinnCdn = "enable_quinn_cdn"
    }
    
    static let `default` = GeneralSettings(
        brandingTextColor: "#6D7278",
        cartProvider: "none",
        cartTagging: false,
        currencySymbol: "₹",
        overlayBrandingTextColor: "#FFFFF",
        reviewProvider: "none",
        shouldLoopOverlay: true,
        showBranding: true,
        showOverlayBranding: true,
        showVideoWatermark: true,
        videoWatermarkTextColor: "#6D7278",
        openCartDrawerOnAddToCart: false,
        preventPriceRound: false,
        swapCurrencySymbol: false,
        storeOffers: "[]",
        enableQuinnCdn: false
    )
}

struct OverlaySettings: Codable {
    let useSwatchImages: Bool
    let cartSelector: String
    let disableOverlayMinimiser: Bool
    let hideElements: String
    let isMuted: Bool
    let moveToNextStory: Bool
    let moveToNextVideo: Bool
    let overlayZIndex: String
    let preventHeaderUpdate: Bool
    let redirectProductClick: Bool
    let redirectUrl: String
    let selectorTypes: String
    let shouldOpenImageOverlay: Bool
    let swatchSelectorKeys: String
    let swipeDirection: SwipeDirection
    let tapToSwitchStory: Bool
    let cartIconSelector: String
    let showMediaTitleInGroupOverlay: Bool
    let showOverlayTitleForAllWidgets: Bool?
    let changeImageOnVariantChange: Bool
    let sortVariantByQuantity: Bool
    let uniformGroupOverlayUx: Bool?
    let closeOverlayBackButton: Bool?
    
    enum SwipeDirection: String, Codable {
        case horizontal, vertical
    }
    
    enum CodingKeys: String, CodingKey {
        case useSwatchImages = "use_swatch_images"
        case cartSelector = "cart_selector"
        case disableOverlayMinimiser = "disable_overlay_minimiser"
        case hideElements = "hide_elements"
        case isMuted = "is_muted"
        case moveToNextStory = "move_to_next_story"
        case moveToNextVideo = "move_to_next_video"
        case overlayZIndex = "overlay_z_index"
        case preventHeaderUpdate = "prevent_header_update"
        case redirectProductClick = "redirect_product_click"
        case redirectUrl = "redirect_url"
        case selectorTypes = "selector_types"
        case shouldOpenImageOverlay = "should_open_image_overlay"
        case swatchSelectorKeys = "swatch_selector_keys"
        case swipeDirection = "swipe_direction"
        case tapToSwitchStory = "tap_to_switch_story"
        case cartIconSelector = "cart_icon_selector"
        case showMediaTitleInGroupOverlay = "show_media_title_in_group_overlay"
        case showOverlayTitleForAllWidgets = "show_overlay_title_for_all_widgets"
        case changeImageOnVariantChange = "change_image_on_variant_change"
        case sortVariantByQuantity = "sort_variant_by_quantity"
        case uniformGroupOverlayUx = "uniform_group_overlay_ux"
        case closeOverlayBackButton = "close_overlay_back_button"
    }
    
    static let `default` = OverlaySettings(
        useSwatchImages: false,
        cartSelector: "",
        disableOverlayMinimiser: false,
        hideElements: "",
        isMuted: true,
        moveToNextStory: false,
        moveToNextVideo: false,
        overlayZIndex: "99999",
        preventHeaderUpdate: false,
        redirectProductClick: false,
        redirectUrl: "",
        selectorTypes: "{\"Size\":\"size\",\"Color\":\"shade\",\"Shade\":\"shade\",\"Flavour\":\"dropdown\"}",
        shouldOpenImageOverlay: false,
        swatchSelectorKeys: "color",
        swipeDirection: .vertical,
        tapToSwitchStory: false,
        cartIconSelector: "",
        showMediaTitleInGroupOverlay: false,
        showOverlayTitleForAllWidgets: false,
        changeImageOnVariantChange: false,
        sortVariantByQuantity: false,
        uniformGroupOverlayUx: false,
        closeOverlayBackButton: false
    )
}

struct CustomiserSettings: Codable {
    let cardCutoffPrice: Bool
    let primaryBtnTitle: String
    let reviewProvider: String
    let secondaryBtnTitle: String
    let tertiaryBtnTitle: String
    let tertiaryBtnVisibility: Bool
    let videoCutoffPriceVisibility: Bool
    
    enum CodingKeys: String, CodingKey {
        case cardCutoffPrice = "card_cutoff_price"
        case primaryBtnTitle = "primaryBtn_title"
        case reviewProvider = "review_provider"
        case secondaryBtnTitle = "secondaryBtn_title"
        case tertiaryBtnTitle = "tertiaryBtn_title"
        case tertiaryBtnVisibility = "tertiaryBtn_visibility"
        case videoCutoffPriceVisibility = "video_cutoff_price_visibility"
    }
    
    static let `default` = CustomiserSettings(
        cardCutoffPrice: true,
        primaryBtnTitle: "Shop now",
        reviewProvider: "none",
        secondaryBtnTitle: "Add to cart",
        tertiaryBtnTitle: "More info",
        tertiaryBtnVisibility: true,
        videoCutoffPriceVisibility: true
    )
}
