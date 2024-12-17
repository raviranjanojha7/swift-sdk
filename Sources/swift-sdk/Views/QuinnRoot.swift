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
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            content
            OverlayView()
        }
    }
}

