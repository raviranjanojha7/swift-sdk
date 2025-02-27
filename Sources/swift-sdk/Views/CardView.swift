//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 05/12/24.
//

import SwiftUI
import AVKit

public struct CardView: View {
    @StateObject private var viewModel: WidgetViewModel
    let playlistId: String
    let pageHandle: String
    let layer: Int
    @ObservedObject private var global = Global.shared
    
    public init(playlistId: String, pageHandle: String, layer: Int) {
        self.playlistId = playlistId
        self.pageHandle = pageHandle
        self.layer = layer
        _viewModel = StateObject(wrappedValue: WidgetViewModel())
        
        // Set the page handle
        if let quinn = Global.shared.quinn {
            var updatedQuinn = quinn
            updatedQuinn.pageHandle = pageHandle
            Global.shared.quinn = updatedQuinn
        }
    }
    
    public var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                cardScrollView
            }
        }
        .task {
            await loadData()
        }
    }
    
    private var cardScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 20) {
                if let media = viewModel.playlist?.media {
                    ForEach(Array(media.enumerated()), id: \.offset) { index, mediaItem in
                        cardButton(for: mediaItem, mediaIndex: index)
                            .id("\(mediaItem.media?.id ?? "")-\(index)")
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func cardButton(for mediaItem: PlaylistMediaItemWithProducts, mediaIndex: Int) -> some View {
        Button(action: {
            handleCardTap(index: mediaIndex)
        }) {
            ProductCardLayout(mediaItem: mediaItem)
        }
    }
    
    private func handleCardTap(index: Int) {
        withAnimation {
            print("Card clicked")
            let newOverlayState = OverlayState(
                activeIndex: index,
                playlist: viewModel.playlist,
                widgetType: .cards,
                handle: ""
            )
            if let quinn = global.quinn {
                var updatedQuinn = quinn
                updatedQuinn.overlayState = newOverlayState
                global.quinn = updatedQuinn
            }
        }
    }
    
    private func loadData() async {
        viewModel.isLoading = true
        defer { viewModel.isLoading = false }
        
        do {
            let connector = try getConnector()
            Task {
                let playlist = try await connector.getPlaylistData(playlistId: playlistId)
                 if let jsonData = try? JSONEncoder().encode(playlist),
                    let jsonString = String(data: jsonData, encoding: .utf8) {
//                     print("Playlist JSON: \(jsonString)")
                 }
                viewModel.updatePlaylist(playlist)
            }
        } catch {
            print("Error loading playlist: \(error)")
        }
    }
}

private struct ProductCardLayout: View {
    let mediaItem: PlaylistMediaItemWithProducts
    
    var body: some View {
        ZStack(alignment: .top) {
            MainProductCard(mediaItem: mediaItem)
            ProductImageOverlay(product: getFirstProduct(from: mediaItem))
        }
        .shadow(radius: 1)
    }
    
    private func getFirstProduct(from mediaItem: PlaylistMediaItemWithProducts) -> MediaProduct? {
        switch mediaItem.type {
        case .media:
            return mediaItem.media?.products.first
        case .group:
            return mediaItem.group?.medias.first?.products.first
        }
    }
}

private struct MainProductCard: View {
    let mediaItem: PlaylistMediaItemWithProducts
    
    var body: some View {
        VStack(spacing: 0) {
            cardContent(for: mediaItem)
                .frame(width: 153, height: 271)
            
            Spacer()
            
            if let product = getFirstProduct(from: mediaItem) {
                ProductInfoSection(product: product)
            }
        }
        .frame(width: 153, height: 360)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private func getFirstProduct(from mediaItem: PlaylistMediaItemWithProducts) -> MediaProduct? {
        switch mediaItem.type {
        case .media:
            return mediaItem.media?.products.first
        case .group:
            return mediaItem.group?.medias.first?.products.first
        }
    }
    
    private func cardContent(for mediaItem: PlaylistMediaItemWithProducts) -> some View {
        Group {
            if mediaItem.type == .media {
                CardItemView(mediaItem: mediaItem)
                    .frame(width: 153, height: 271)
            } else if mediaItem.type == .group {
                groupContent(for: mediaItem)
            }
        }
    }
    
    private func groupContent(for mediaItem: PlaylistMediaItemWithProducts) -> some View {
        Group {
            if let group = mediaItem.group, !group.medias.isEmpty {
                CardItemView(
                    mediaItem: PlaylistMediaItemWithProducts(
                        type: .media,
                        group: nil,
                        media: group.medias[0]
                    )
                )
                .frame(width: 153, height: 271)
            } else {
                EmptyView()
            }
        }
    }
}

private struct ProductInfoSection: View {
    let product: MediaProduct
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
                .frame(height: 15)
            
            Text(product.title.split(separator: "|").first?.trimmingCharacters(in: .whitespaces) ?? product.title)
                .font(.system(size: 12, weight: .bold))
                .lineLimit(1)
                .foregroundColor(.black)
            
            PriceDisplay(product: product)
        }
        .padding(8)
        .frame(width: 153)
        .background(Color.white)
        .clipShape(CustomCornerShape(corners: [.bottomLeft, .bottomRight], radius: 4))
    }
}

private struct PriceDisplay: View {
    let product: MediaProduct
    
    var body: some View {
        HStack(spacing: 4) {
            Text("₹\(product.price_min)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.black)
            
            if let comparePrice = Double(product.compare_at_price_max_number),
               let price = Double(product.price_min),
               comparePrice > price {
                Text("₹\(product.compare_at_price_max_number)")
                    .font(.system(size: 10))
                    .strikethrough()
                    .foregroundColor(.gray)
                
                let discount = Int(((comparePrice - price) / comparePrice) * 100)
                Text("\(discount)% off")
                    .font(.system(size: 10))
                    .foregroundColor(.green)
            }
        }
    }
}

private struct ProductImageOverlay: View {
    let product: MediaProduct?
    
    var body: some View {
        if let product = product {
            AsyncImage(url: URL(string: product.images.first?.url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                    .background(Color.white)
            } placeholder: {
                Color.gray
                    .frame(width: 40, height: 40)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
            )
            .offset(y: 251)
        }
    }
}

// Separate view for individual card items
private struct CardItemView: View {
    let mediaItem: PlaylistMediaItemWithProducts
    
    var body: some View {
        ZStack {
            if let media = mediaItem.media {
                if let videoUrl = media.urls?.short {
                    VideoPlayer(
                        url: URL(string: videoUrl),
                        isMuted: .constant(true)
                    )
                        .aspectRatio(9/16, contentMode: .fill)
                        .frame(width: 153, height: 271)
                        .clipShape(CustomCornerShape(corners: [.topLeft, .topRight], radius: 8))
                        .allowsHitTesting(false)
                } else if let posterUrl = media.urls?.poster {
                    AsyncImage(url: URL(string: posterUrl)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(9/16, contentMode: .fill)
                                .allowsHitTesting(false)
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                                .allowsHitTesting(false)
                        case .empty:
                            ProgressView()
                                .allowsHitTesting(false)
                        @unknown default:
                            ProgressView()
                                .allowsHitTesting(false)
                        }
                    }
                    .frame(width: 153, height: 271)
                    .clipShape(CustomCornerShape(corners: [.topLeft, .topRight], radius: 8))
                }
            }
        }
        .shadow(radius: 4)
    }
}

struct CustomCornerShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    QuinnRoot(
        sft: "44a96721cac4ae4138b4e3598cfdea12",
        cdn: "//cdn.shopify.com/s/files/1/0057/8938/4802/files/",
        shopDomain: "boatlifestylein.myshopify.com",
        shopType: .shopify
    ) {
        CardView(
            playlistId: "INDEX_index_STORY_1",
            pageHandle: "your_page_handle",
            layer: 1
        )
    }
}
