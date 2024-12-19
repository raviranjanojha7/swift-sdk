//
//  OverlayViewModel.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import SwiftUI

//public class OverlayViewModel: ObservableObject {
//    @Published public var bundles: [CardAndStoryBundle] = [
//        CardAndStoryBundle(profileName: "Canada", medias: [
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
//        ]),
//
//        CardAndStoryBundle(profileName: "Mexico", medias: [
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true)
//        ]),
//
//        CardAndStoryBundle(profileName: "Tajikistan", medias: [
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_wj3yj65nlj5wjjw3kolikmm0.mp4", isVideo: true),
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true),
//        ]),
//        CardAndStoryBundle(profileName: "China", medias: [
//            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
//        ])
//    ]
//
//    public init() {}
//    
//    @Published public var showOverlay: Bool = false
//    @Published public var currentBundle: String = ""
//
//    public func nextBundleID(currentID: String) -> String? {
//        guard let currentIndex = bundles.firstIndex(where: { $0.id == currentID }), 
//              currentIndex + 1 < bundles.count else { return nil }
//        return bundles[currentIndex + 1].id
//    }
//
//    public func previousBundleID(currentID: String) -> String? {
//        guard let currentIndex = bundles.firstIndex(where: { $0.id == currentID }), 
//              currentIndex - 1 >= 0 else { return nil }
//        return bundles[currentIndex - 1].id
//    }
//}

extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

@MainActor
class OverlayViewModel: ObservableObject {
    let global  = Global.shared
    // MARK: - Published Properties
    @Published var isLoading = false
    @Published var activeIndex = 0
    @Published var initialIndex = 0
    @Published var groupMediaIndex = 0
    @Published var widgetType: WidgetType = WidgetType.cards
    @Published var playlistId = ""
    @Published var playlist: PlaylistData?
    @Published var mediaData: [String: PlaylistMediaItem] = [:]
    @Published var selectedProduct: MediaProduct?
    @Published var selectedVariant: Variant?
    @Published var handle = ""
    @Published var isOverlayMuted = true
    @Published var scrollDirection: ScrollDirection = .horizontal
    
    // MARK: - Types
    enum ScrollDirection { 
        case horizontal
        case vertical
    }
    
    func overlayInfoToggle(payload: String) {
        Task { @MainActor in
            global.quinn!.functions.overlayInfoToggle(mediaKey: payload)
        }
    }
    
    func redirectToProduct(payload: MediaProduct) {
        Task { @MainActor in
            if let selectedProduct = selectedProduct {
                global.quinn!.functions.redirectToProduct(product: selectedProduct)
            }
        }
    }
    
    func closeOverlay() {
        Task { @MainActor in
            global.quinn!.functions.closeOverlay()
        }
    }
    
    func openCartDrawer() {
        Task { @MainActor in
            global.quinn!.functions.openCartDrawer()
        }
    }
    
    func addToCart(dataId: String) {

    }
    
    func updateAppCart(cart: ShopifyCart? = nil) {

    }
    
    func ctaRedirect() {
    }
    
    private func extractPageId(from link: String) -> String? {
        guard let pidRange = link.range(of: "pid=") else { return nil }
        let start = link[pidRange.upperBound...]
        guard let end = start.firstIndex(of: "&") else {
            return String(start)
        }
        return String(start[..<end])
    }

}






