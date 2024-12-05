//
//  Model.swift
//  Insta-medias
//
//  Created by Ravi Ranjan Ojha on 19/03/24.
//

import Foundation

//Numbers of medias for users
public struct CardAndStoryBundle: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var profileName: String
    public var medias: [CardAndStory]
    
    public init(profileName: String, medias: [CardAndStory]) {
        self.profileName = profileName
        self.medias = medias
    }
}

public struct CardAndStory: Identifiable, Hashable {
    public var id = UUID().uuidString
    public var mediaURL: String
    public var isVideo: Bool
    
    public init(mediaURL: String, isVideo: Bool) {
        self.mediaURL = mediaURL
        self.isVideo = isVideo
    }
}


