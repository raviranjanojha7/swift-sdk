//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 03/01/25.
//

import Foundation

class SessionManager {
    private static let version = 1
    private static let sessionMaxAge: TimeInterval = 30 * 60 // 30 minutes in seconds
    
    static func getUUID() -> String {
        UUID().uuidString
    }
    
    static func getDistinctId() async -> String {
        let key = "_quinn-distinctid-id-\(version)"
        
        if let distinctId = UserDefaults.standard.string(forKey: key) {
            return distinctId
        }
        
        let newDistinctId = getUUID()
        UserDefaults.standard.set(newDistinctId, forKey: key)
        UserDefaults.standard.synchronize()
        return newDistinctId
    }
    
    struct SessionData: Codable {
        let sessionId: String
        let expiryStamp: Date
    }
    
    static func getSessionId() async -> (sessionId: String, newSession: Bool) {
        let key = "_quinn_session_id-\(version)"
        
        if let sessionData = UserDefaults.standard.data(forKey: key),
           let session = try? JSONDecoder().decode(SessionData.self, from: sessionData) {
            if Date() < session.expiryStamp {
                return (session.sessionId, false)
            }
        }
        
        let sessionId = getUUID()
        let expiryStamp = Date().addingTimeInterval(sessionMaxAge)
        let newSession = SessionData(sessionId: sessionId, expiryStamp: expiryStamp)
        
        if let encodedSession = try? JSONEncoder().encode(newSession) {
            UserDefaults.standard.set(encodedSession, forKey: key)
            UserDefaults.standard.synchronize()
        }
        
        return (sessionId, true)
    }
}
