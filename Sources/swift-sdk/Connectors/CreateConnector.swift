//
//  File 4.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 10/12/24.
//

import Foundation
import SwiftUI




func createConnector(payload: Connector) throws -> BaseConnector {
    switch payload.shopType {
    case .shopify:
        return ShopifyConnector(shop: payload.shop, accessToken: payload.accessToken)
    case .general:
        return GeneralConnector(shop: payload.shop, accessToken: payload.accessToken)
    default:
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid shop type"])
    }
}

@MainActor
func getConnector() throws -> BaseConnector {
    let currentGlobalState = Global.shared
    
    let connectorPayload = Connector(
        shop: currentGlobalState.shopDomain,
        accessToken: currentGlobalState.sft,
        shopType: currentGlobalState.shopType
    )
    
    do {
        let connector = try createConnector(payload: connectorPayload)
        return connector;
    } catch {
        print("Failed to create connector: \(error.localizedDescription)")
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get connector"])
    }
}


