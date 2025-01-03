//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 17/12/24.
//

import SwiftUI

public struct QuinnRoot<Content: View>: View {
    let content: Content
    @StateObject private var global = Global.shared
    @State private var isInitialized = false
    let sft: String
    let cdn: String
    let shopDomain: String
    let shopType: ShopType
    let addToCart: (ProductAndVariant) async throws -> Void
    let redirectToProduct: (ProductAndVariant) -> Void
    
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
        self.sft = sft
        self.cdn = cdn
        self.shopDomain = shopDomain
        self.shopType = shopType
        self.addToCart = addToCart
        self.redirectToProduct = redirectToProduct
    }
    
    public var body: some View {
        ZStack {
            if isInitialized {
                content
                OverlayView()
            } else {
                ProgressView()
            }
        }
        .task {
            if Global.shared.quinn == nil {
                print("Initializing Quinn...")
                let distinctId = await SessionManager.getDistinctId()
                let (sessionId, _) = await SessionManager.getSessionId()
                
                let functions = DefaultQuinnFunctions(
                    addToCart: addToCart,
                    redirectToProduct: redirectToProduct
                )
                
                Global.shared.quinn = Quinn(
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
                print("Quinn initialization complete")
            }
            isInitialized = true
        }
    }
}



