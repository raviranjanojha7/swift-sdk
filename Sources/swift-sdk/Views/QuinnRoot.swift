//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 17/12/24.
//

import SwiftUI

public struct QuinnRoot<Content: View>: View {
    let content: Content
    let global = Global.shared
    
    public init(
        sft: String = "",
        cdn: String,
        shopDomain: String,
        shopType: ShopType = .shopify,
        addToCart: @escaping (ProductAndVariant) async throws -> Void = { _ in },
        redirectToProduct: @escaping (ProductAndVariant) -> Void = { _ in },
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        
        if global.quinn == nil {
            let functions = DefaultQuinnFunctions(
                addToCart: addToCart,
                redirectToProduct: redirectToProduct
            )
            
            global.quinn = Quinn(
                sft: sft,
                cdn: cdn,
                shopDomain: shopDomain,
                shopType: shopType,
                apiCache: [:],
                functions: functions,
                currencySymbol: "₹",
                settings: QuinnSettings(),
                appId: "5905719",
                pageType: nil,
                pageId: nil,
                pageHandle: nil,
                overlayState: nil,
                overlayLoadStartTime: nil,
                overlayLoadEndTime: nil,
                overlayOpenTime: nil,
                overlayDuration: nil,
                overlayWidth: nil,
                overlayHeight: nil,
                disableGradient: nil,
                videoResizeMode: nil,
                fontFamily: nil,
                version: "1.0.0",
                styles: nil
            )
        }
    }
    
    public var body: some View {
        ZStack {
            content
            OverlayView()
        }
    }
}



