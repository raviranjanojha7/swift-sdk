//
//  OverlayViewModel.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import SwiftUI

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
    @Published var playlist: PlaylistDataWithProducts?
    @Published var mediaData: [String: PlaylistMediaItemWithProducts] = [:]
    @Published var selectedProduct: MediaProduct?
    @Published var selectedVariant: ProductVariant?
    @Published var handle = ""
    @Published var isOverlayMuted = true
    @Published var scrollDirection: ScrollDirection = .horizontal
    @Published var isMuted: Bool = false
    @Published var overlayOpenedTime: Date?
    
    // MARK: - Types
    enum ScrollDirection { 
        case horizontal
        case vertical
    }
    
    func redirectToProduct() {
        guard let selectedProduct = selectedProduct,
              let selectedVariant = selectedVariant,
              let quinn = global.quinn else { return }
        quinn.functions.redirectToProduct(payload: ProductAndVariant(product: selectedProduct, variant: selectedVariant))
    }
    
    func addToCart() {
        guard let selectedProduct = selectedProduct,
              let selectedVariant = selectedVariant,
              let quinn = global.quinn else { return }
        
        Task {
            do {
                try await quinn.functions.addToCart(payload: ProductAndVariant(product: selectedProduct, variant: selectedVariant))
            } catch {
                print("Error adding to cart: \(error)")
            }
        }
    }
    
    private func extractPageId(from link: String) -> String? {
        guard let pidRange = link.range(of: "pid=") else { return nil }
        let start = link[pidRange.upperBound...]
        guard let end = start.firstIndex(of: "&") else {
            return String(start)
        }
        return String(start[..<end])
    }
    
    func getMediaId() -> String {
        if let mediaItem = mediaData[String(activeIndex)] {
            if mediaItem.type == .media {
                return mediaItem.media?.id ?? ""
            } else if mediaItem.type == .group {
                if let group = mediaItem.group,
                   let currentMedia = group.medias[safe: groupMediaIndex] {
                    return currentMedia.id
                }
            }
        }
        return ""
    }
    
    func getGroupId() -> String {
        if let mediaItem = mediaData[String(activeIndex)],
           mediaItem.type == .group {
            return mediaItem.group?.id ?? ""
        }
        return ""
    }
    
    func getPlaylistId() -> String {
           return playlist?.id ?? ""
       }
       
       func getWidgetType() -> String {
           return widgetType.rawValue
       }
}






