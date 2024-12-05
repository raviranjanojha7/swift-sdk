//
//  OverlayViewModel.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import SwiftUI

public class OverlayViewModel: ObservableObject {
    @Published public var bundles: [CardAndStoryBundle] = [
        CardAndStoryBundle(profileName: "Canada", medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
        ]),

        CardAndStoryBundle(profileName: "Mexico", medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true)
        ]),

        CardAndStoryBundle(profileName: "Tajikistan", medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_wj3yj65nlj5wjjw3kolikmm0.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true),
        ]),
        CardAndStoryBundle(profileName: "China", medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
        ])
    ]

    public init() {}
    
    @Published public var showOverlay: Bool = false
    @Published public var currentBundle: String = ""

    public func nextBundleID(currentID: String) -> String? {
        guard let currentIndex = bundles.firstIndex(where: { $0.id == currentID }), 
              currentIndex + 1 < bundles.count else { return nil }
        return bundles[currentIndex + 1].id
    }

    public func previousBundleID(currentID: String) -> String? {
        guard let currentIndex = bundles.firstIndex(where: { $0.id == currentID }), 
              currentIndex - 1 >= 0 else { return nil }
        return bundles[currentIndex - 1].id
    }
}



