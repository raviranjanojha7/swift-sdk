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
                
                TabView(selection: $viewModel.activeIndex) {
                    ForEach(Array(playlist.media.enumerated()), id: \.element) { index, mediaItem in
                        OverlayCardView(
                            mediaItem: mediaItem,
                            index: index,
                            viewModel: viewModel
                        )
                        .tag(index)
                        .id("\(mediaItem.media?.id ?? "")-\(index)")
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
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
                // First set the playlist
                viewModel.playlist = overlayState.playlist
                
                // Then set the active index with a slight delay to ensure proper initialization
                DispatchQueue.main.async {
                    viewModel.activeIndex = overlayState.activeIndex ?? 0
                    viewModel.widgetType = overlayState.widgetType ?? .story
                    viewModel.handle = overlayState.handle ?? ""
                }
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
