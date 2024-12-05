//
//  Model.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import Foundation

//Numbers of stories for users
public struct StoryBundle: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var profileName: String
    public var stories: [Story]
    
    public init(profileName: String, stories: [Story]) {
        self.profileName = profileName
        self.stories = stories
    }
}

public struct Story: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var mediaURL: String
    public var isVideo: Bool
    
    public init(mediaURL: String, isVideo: Bool) {
        self.mediaURL = mediaURL
        self.isVideo = isVideo
    }
}

public struct CardBundle: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var profileName: String
    public var cards: [Card]
    
    public init(profileName: String, cards: [Card]) {
        self.profileName = profileName
        self.cards = cards
    }
}

public struct Card: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var mediaURL: String
    public var isVideo: Bool
    
    public init(mediaURL: String, isVideo: Bool) {
        self.mediaURL = mediaURL
        self.isVideo = isVideo
    }
}
