//
//  MainView.swift
//  Insta-bundles
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI

public struct MainView: View {
    @ObservedObject private var global = Global.shared
    
    public var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Story Section
                    StoryView(
                        playlistId: "your_story_playlist_id",
                        pageHandle: "your_page_handle",
                        layer: 1
                    )
                    
                    // Card Section
                    CardView(
                        playlistId: "your_card_playlist_id",
                        pageHandle: "your_page_handle",
                        layer: 1
                    )
                }
            }
            // Overlay will be shown when overlayState is not nil
            .overlay {
                OverlayView()
            }
        }
    }
}

#Preview {
    MainView()
}
