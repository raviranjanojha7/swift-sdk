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
        ZStack { 
            if let overlayState = global.quinn.overlayState,
               let playlist = overlayState.playlist {
                TabView(selection: $viewModel.activeIndex) {
                    ForEach(Array(playlist.media.enumerated()), id: \.element.media?.id) { index, mediaItem in
                        OverlayCardView(
                            mediaItem: mediaItem,
                            viewModel: viewModel
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .opacity(fade ? 0.3 : 1)
                .offset(y: offset.height)
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { gesture in
                            guard gesture.translation.height > .zero else { return }
                            if gesture.translation.height > 20 {
                                withAnimation {
                                    offset = gesture.translation
                                    fade = true
                                }
                            }
                        }
                        .onEnded { gesture in
                            if gesture.translation.height > 100 {
                                withAnimation {
                                    global.quinn.overlayState = nil // Close overlay
                                }
                            }
                            withAnimation {
                                offset = .zero
                                fade = false
                            }
                        }
                )
                .onAppear {
                    // Copy data from global state to viewModel
                    viewModel.playlist = overlayState.playlist
                    viewModel.activeIndex = overlayState.activeIndex ?? 0
                    viewModel.widgetType = overlayState.widgetType ?? .story
                    viewModel.handle = overlayState.handle ?? ""
                }
            }
        }
    }
}

#Preview {
    OverlayView()
}
