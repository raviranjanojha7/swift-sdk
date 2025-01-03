//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 02/01/25.
//

import Foundation

@MainActor
class RequestManager {
    static let shared = RequestManager()
    private let eventsUrl = "https://events.quinn.live/events"
    
    private init() {}
    
    private func getStoreName() -> String {
        return Global.shared.quinn?.shopDomain ?? ""
    }
    
    private func getClientInfo() -> [String: String] {
        return [
            "os": "iOS",
            "device": "mobile"
        ]
    }
    
    func sendEvent(eventName: String, payload: [String: Any]) {
        guard let eventNameWithoutPrefix = eventName.split(separator: "_", maxSplits: 1).last else { return }
        
        let clientInfo = getClientInfo()
        let storeName = getStoreName()
        let version = Global.shared.quinn?.version ?? ""
        
        // Separate measures (data) from dimensions
        let measures = payload["data"] as? [String: Any] ?? [:]
        var dimensions = payload
        dimensions.removeValue(forKey: "data")
        
        let eventId = UUID().uuidString
        
        // TODO: Implement session and distinct ID logic
        let sessionId = "temp_session_id"
        let distinctId = "temp_distinct_id"
        let newSession = false
        
        // Construct event payload
        var eventPayload: [String: Any] = [
            "eventname": eventNameWithoutPrefix,
            "sessionid": sessionId,
            "distinctid": distinctId,
            "storename": storeName,
            "timestamp": Date().timeIntervalSince1970 * 1000, // Convert to milliseconds
            "appversion": version,
            "data": [
                "eventid": eventId
            ] as [String: Any],
            "source": "ios-sdk"
        ]
        
        // Add measures to data
        if !measures.isEmpty {
            eventPayload["data"] = measures.merging(["eventid": eventId]) { (_, new) in new }
        }
        
        // Add dimensions and client info
        eventPayload.merge(dimensions) { (_, new) in new }
        eventPayload.merge(clientInfo) { (_, new) in new }
        
        // Send new session event if needed
        if newSession {
            let sessionPayload: [String: Any] = [
                "eventname": "events_user_session_created",
                "sessionid": sessionId,
                "distinctid": distinctId,
                "storename": storeName,
                "appversion": version,
                "timestamp": Date().timeIntervalSince1970 * 1000,
                "data": [
                    "eventid": eventId
                ]
            ]
            sendBeacon(payload: sessionPayload.merging(clientInfo) { (_, new) in new })
        }
        
        // Handle first page view
        if newSession && eventName == "quinn_events_page_view" {
            eventPayload["type"] = "first"
        }
        
        // Send the event
        sendBeacon(payload: eventPayload)
    }
    
    private func sendBeacon(payload: [String: Any]) {
        guard let url = URL(string: eventsUrl),
              let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error sending event: \(error)")
            }
        }.resume()
    }
    
}
