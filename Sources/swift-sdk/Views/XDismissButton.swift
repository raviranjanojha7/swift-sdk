//
//  XDismissButton.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 06/12/24.
//


import SwiftUI

struct XDismissButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 35, height: 35)
                .foregroundColor(.black)
                .opacity(0.7)
            
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    XDismissButton()
}
