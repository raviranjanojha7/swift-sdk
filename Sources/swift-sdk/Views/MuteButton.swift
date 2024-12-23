//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 23/12/24.
//

import SwiftUI

struct MuteButton: View {
    @Binding var isMuted: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 35, height: 35)
                .foregroundColor(.black)
                .opacity(0.7)
            
            Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.white)
        }
    }
}

#Preview {
    MuteButton(isMuted: .constant(false))
}
