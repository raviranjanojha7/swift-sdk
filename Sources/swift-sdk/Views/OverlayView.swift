//
//  OverlayView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 30/03/24.
//

import SwiftUI

public struct OverlayView: View {
    @StateObject var viewModel: OverlayViewModel
    @ObservedObject private var global = Global.shared
    
    @State private var offset = CGSize.zero
    @State private var fade: Bool = false
    
    public init() {
        _viewModel = StateObject(wrappedValue: OverlayViewModel())
    }
    
    public var body: some View {
        if let overlayState = global.quinn.overlayState,
           let playlist = overlayState.playlist {
            ZStack {
                Color.black
                    .edgesIgnoringSafeArea(.all)
                
                LazyTabView(
                    count: playlist.media.count,
                    selection: $viewModel.activeIndex
                ) { index in
                    OverlayCardView(
                        mediaItem: playlist.media[index],
                        viewModel: viewModel
                    )
                }
            }
            .opacity(fade ? 0.3 : 1)
            .offset(y: offset.height)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.height > 0 {
                            withAnimation(.interactiveSpring()) {
                                offset = gesture.translation
                                fade = true
                            }
                        }
                    }
                    .onEnded { gesture in
                        withAnimation(.interactiveSpring()) {
                            if gesture.translation.height > 100 {
                                global.quinn.overlayState = nil
                            } else {
                                offset = .zero
                                fade = false
                            }
                        }
                    }
            )
            .onAppear {
                print(overlayState.activeIndex)
                viewModel.playlist = overlayState.playlist
                viewModel.activeIndex = overlayState.activeIndex ?? 0
                viewModel.widgetType = overlayState.widgetType ?? .story
                viewModel.handle = overlayState.handle ?? ""
            }
            .transition(.opacity)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    OverlayView()
}
