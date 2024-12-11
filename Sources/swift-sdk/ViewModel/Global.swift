//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 11/12/24.
//

import Foundation

@MainActor
final class Global: ObservableObject {
    static let shared = Global()
    
    @Published var quinn: Quinn
    
    private init() {
        self.quinn = Quinn(
            sft: "",
            cdn: "",
            shopDomain: "",
            shopType: .shopify,
            apiCache: [:],
            functions: DefaultQuinnFunctions(),
            currencySymbol: "₹",
            settings: .default,
            appId: "5905719",
            pageType: nil,
            pageId: nil,
            pageHandle: nil,
            overlayState: .default,
            overlayLoadStartTime: nil,
            overlayLoadEndTime: nil,
            overlayOpenTime: nil,
            overlayDuration: nil,
            overlayWidth: nil,
            overlayHeight: nil,
            disableGradient: nil,
            videoResizeMode: nil,
            fontFamily: nil,
            version: "",
            styles: nil
        )
    }
}

@MainActor
func initApp(config: AppConfig) {
    let appState = Global.shared
    
    appState.quinn = Quinn(
        sft: config.sft ?? "",
        cdn: config.cdn,
        shopDomain: config.shopDomain,
        shopType: config.shopType,
        apiCache: [:],
        functions: DefaultQuinnFunctions(),
        currencySymbol: "₹",
        settings: .default,
        appId: "5905719",
        pageType: nil,
        pageId: nil,
        pageHandle: nil,
        overlayState: .default,
        overlayLoadStartTime: nil,
        overlayLoadEndTime: nil,
        overlayOpenTime: nil,
        overlayDuration: nil,
        overlayWidth: nil,
        overlayHeight: nil,
        disableGradient: nil,
        videoResizeMode: nil,
        fontFamily: nil,
        version: "",
        styles: nil
    )
}

