//
//  StoryView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct StoryView: View {

    @Binding var stories: StoryBundle
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject var viewModel: StoryViewModel

     public init(stories: Binding<StoryBundle>) {
        self._stories = stories
    }

    public var body: some View {
        ZStack {
            if let firstStory = stories.stories.first {
                if firstStory.isVideo {
                    VideoPlayer(url: URL(string: firstStory.mediaURL))
                        .aspectRatio(contentMode: .fill)
                        .allowsHitTesting(false)
                } else {
                    AsyncImage(url: URL(string: firstStory.mediaURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .allowsHitTesting(false)
                        case .failure(_):
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .allowsHitTesting(false)
                        case .empty:
                            ProgressView()
                                .allowsHitTesting(false)
                        @unknown default:
                            ProgressView()
                                .allowsHitTesting(false)
                        }
                    }
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .allowsHitTesting(false)
            }
        }
        .frame(width: 60, height: 60)
        .clipShape(Circle())
        .padding(3)
        .background(
            LinearGradient(
                colors: [.red, .orange, .yellow, .orange],
                startPoint: .top, endPoint: .bottom
            )
            .clipShape(Circle())
        )
        .onTapGesture {
            print("Profile View Tapped - Debug")
            withAnimation {
                viewModel.currentStory = stories.id
                viewModel.showStory = true
            }
        }
    }
}




#Preview {
    StoryView(stories: .constant(StoryBundle(
        profileName: "Canada", 
        stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: false),
        ]
    )))
    .environmentObject(StoryViewModel())
}
