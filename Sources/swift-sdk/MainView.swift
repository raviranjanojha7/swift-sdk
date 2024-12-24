//
//  MainView.swift
//  Insta-bundles
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI


public struct MainView: View {
    // initApp({
    //     sft: '22e0fed6b155ff224bd1e3eba1b71b45',
    //     cdn: '//cdn.shopify.com/s/files/1/0049/3649/9315/files/',
    //     shop_domain: 'koskii.myshopify.com',
    //     shop_type: 'SHOPIFY'
    // });
    
    public var body: some View {
        QuinnRoot(
            sft: "22e0fed6b155ff224bd1e3eba1b71b45",
            cdn: "//cdn.shopify.com/s/files/1/0049/3649/9315/files/",
            shopDomain: "koskii.myshopify.com",
            shopType: .shopify
        ) {
            NavigationStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Story Section
//                        StoryView(
//                            playlistId: "INDEX_index_CARD_1",
//                            pageHandle: "your_page_handle",
//                            layer: 1
//                        )
                        
                        // Card Section
                        CardView(
                            playlistId: "INDEX_index_CARD_1",
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
