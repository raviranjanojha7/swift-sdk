//
//  StoryViewModel.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import SwiftUI

public class StoryViewModel: ObservableObject {
    @Published public var stories: [StoryBundle] = [
        StoryBundle(profileName: "Canada", stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_krc7ksul4krxdnfhyr2cwhld.mp4", isVideo: true)
        ]),

        StoryBundle(profileName: "Mexico", stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true)
        ]),

        StoryBundle(profileName: "Tajikistan", stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_wj3yj65nlj5wjjw3kolikmm0.mp4", isVideo: true),
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_iopw61jyiqp2ur4lkmb8v99z.mp4", isVideo: true),
        ]),
        StoryBundle(profileName: "China", stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
        ])
    ]

     public init() {}
    
    
    @Published public var showStory: Bool = false

    //unique stories
    @Published public var currentStory: String = ""

    public func nextStoryID(currentID: String) -> String? {
        guard let currentIndex = stories.firstIndex(where: { $0.id == currentID }), currentIndex + 1 < stories.count else { return nil }
        return stories[currentIndex + 1].id
    }

    public func previousStoryID(currentID: String) -> String? {
        guard let currentIndex = stories.firstIndex(where: { $0.id == currentID }), currentIndex - 1 >= 0 else { return nil }
        return stories[currentIndex - 1].id
    }
}



