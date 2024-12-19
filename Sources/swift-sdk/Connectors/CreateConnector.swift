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
        return ShopifyConnector(shop: payload.shop, accessToken: payload.accessToken, cdn: payload.cdn)
    case .general:
        return GeneralConnector(shop: payload.shop, accessToken: payload.accessToken, cdn: payload.cdn)
    default:
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid shop type"])
    }
}

@MainActor
func getConnector() throws -> BaseConnector {
    let currentGlobalState = Global.shared
    
    guard let quinn = currentGlobalState.quinn else {
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Quinn is not initialized"])
    }
    
    let connectorPayload = Connector(
        shop: quinn.shopDomain,
        cdn: quinn.cdn,
        accessToken: quinn.sft,
        shopType: quinn.shopType
    )
    
    do {
        let connector = try createConnector(payload: connectorPayload)
        return connector
    } catch {
        print("Failed to create connector: \(error.localizedDescription)")
        throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get connector"])
    }
}


