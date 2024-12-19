//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 11/12/24.
//

import Foundation

@MainActor
public class Global: ObservableObject {
    public static let shared = Global()
    
    @Published public var quinn: QuinnProtocol? {
        willSet {
            if let newQuinn = newValue as? QuinnProtocol {
                objectWillChange.send()
            }
        }
    }
    
    private init() {}
}



