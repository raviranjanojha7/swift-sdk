//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 05/12/24.
//

import Foundation

public class CardViewModel: ObservableObject {
    @Published public var cards: [CardBundle] = [
        CardBundle(profileName: "Canada", cards: [
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
        ]),

        CardBundle(profileName: "Mexico", cards: [
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true)
        ]),

        CardBundle(profileName: "Tajikistan", cards: [
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_wj3yj65nlj5wjjw3kolikmm0.mp4", isVideo: true),
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true),
        ]),
        CardBundle(profileName: "China", cards: [
            Card(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
        ])
    ]

     public init() {}
    
    
    @Published public var showCard: Bool = false

    //unique cards
    @Published public var currentCard: String = ""

    public func nextCardID(currentID: String) -> String? {
        guard let currentIndex = cards.firstIndex(where: { $0.id == currentID }), currentIndex + 1 < cards.count else { return nil }
        return cards[currentIndex + 1].id
    }

    public func previousCardID(currentID: String) -> String? {
        guard let currentIndex = cards.firstIndex(where: { $0.id == currentID }), currentIndex - 1 >= 0 else { return nil }
        return cards[currentIndex - 1].id
    }
}