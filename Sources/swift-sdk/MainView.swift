//
//  MainView.swift
//  Insta-bundles
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI


public struct MainView: View {
    
    public var body: some View {
        QuinnRoot(
            sft: "44a96721cac4ae4138b4e3598cfdea12",
            cdn: "//cdn.shopify.com/s/files/1/0057/8938/4802/files/",
            shopDomain: "boatlifestylein.myshopify.com",
            shopType: .shopify
        ) {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Story Section
                        StoryView(
                            playlistId: "INDEX_index_STORY_1",
                            pageHandle: "your_page_handle",
                            layer: 1
                        )
                        
                        // Card Section
                        CardView(
                            playlistId: "INDEX_index_STORY_1",
                            pageHandle: "your_page_handle",
                            layer: 1
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    MainView()
}
