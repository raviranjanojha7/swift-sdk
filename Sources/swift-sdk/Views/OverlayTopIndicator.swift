//
//  OverlayTopIndicator.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI

struct OverlayTopIndicator: View {

    @Binding var bundle: CardAndStoryBundle
    @Binding var timerProgress: CGFloat

    var body: some View {
        HStack(spacing: 5) {
            ForEach(bundle.medias.indices, id: \.self) { index in
                GeometryReader { geometry in
                    let width = geometry.size.width

                    //getting progress by eliminating current index with progress
                    //remaining will be at 0 when previously is loading.

                    //for perfect timer
                    let progress = timerProgress - CGFloat(index)
                    let perfectProgress = min(max(progress, 0), 1)

                    Capsule()
                        .fill(.gray.opacity(0.5))
                        .frame(height: 3)

                        .overlay(
                            Capsule()
                                .fill(.white)
                                .frame(width: width * perfectProgress, height: 3)
                                .animation(.interactiveSpring(duration: 0.1), value: perfectProgress)
                            , alignment: .leading
                        )
                }

            }
        }
    }
}



#Preview {
    OverlayTopIndicator(bundle: .constant(CardAndStoryBundle(profileName: "Canada", medias: [
        CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
        CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
    ])), timerProgress: .constant(1.0))
}
