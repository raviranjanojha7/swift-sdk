//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 05/12/24.
//

import SwiftUI
import AVKit

public struct CardView: View {
    @Binding var bundles: CardAndStoryBundle
    @EnvironmentObject var viewModel: OverlayViewModel
    
    public init(bundles: Binding<CardAndStoryBundle>) {
        self._bundles = bundles
    }
    
    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                if let firstCard = bundles.medias.first {
                    Button {
                        print("Card tapped - Debug")
                        withAnimation {
                            viewModel.currentBundle = bundles.id
                            viewModel.showOverlay = true
                        }
                    } label: {
                        CardItemView(card: firstCard, cardBundle: bundles)
                            .frame(width: 151, height: 271)
                    }
                }
            }
            .padding(10)
        }
    }
}

// Separate view for individual card items
private struct CardItemView: View {
    let card: CardAndStory
    let cardBundle: CardAndStoryBundle
    @EnvironmentObject var viewModel: OverlayViewModel
    
    var body: some View {
        ZStack {
            if card.isVideo {
                VideoPlayer(url: URL(string: card.mediaURL))
                    .aspectRatio(9/16, contentMode: .fill)
                    .frame(width: 151, height: 271)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .allowsHitTesting(false)
            } else {
                AsyncImage(url: URL(string: card.mediaURL)) { phase in
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
                .frame(width: 151, height: 271)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            VStack {
                Spacer()
                productDetailsOverlay
            }
        }
        .shadow(radius: 4)
    }
    
    private var productDetailsOverlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(cardBundle.profileName)
                .font(.system(size: 14, weight: .semibold))
            HStack {
                Text("₹ 999")
                    .font(.system(size: 14, weight: .bold))
                Text("₹ 3,999")
                    .strikethrough()
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("75% off")
                    .font(.system(size: 12))
                    .foregroundColor(.green)
            }
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
    }
}

#Preview {
    CardView(bundles: .constant(CardAndStoryBundle(
        profileName: "Canada",
        medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
        ]
    )))
    .environmentObject(OverlayViewModel())
}
