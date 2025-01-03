//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 30/12/24.
//

import Foundation

class WatchTimeManager {
    @MainActor static let shared = WatchTimeManager()
    private var watchTimeoutWorkItem: DispatchWorkItem?
    
    private init() {}
    
    func trackMediaWatchTime() {
        // Cancel any existing timeout
        watchTimeoutWorkItem?.cancel()
        
        // Create new timeout
        let workItem = DispatchWorkItem { [weak self] in
//            EventsManager.shared.viewCountEvent()
        }
        
        // Schedule the new timeout
        watchTimeoutWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: workItem)
    }
    
    func cancelTracking() {
        watchTimeoutWorkItem?.cancel()
        watchTimeoutWorkItem = nil
    }
}
