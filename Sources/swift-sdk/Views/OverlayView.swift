//
//  OverlayView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 30/03/24.
//

import SwiftUI

struct OverlayView: View {
    @EnvironmentObject var viewModel: OverlayViewModel

    @State private var offset = CGSize.zero
    @State private var fade: Bool = false

    var body: some View {
        if viewModel.showOverlay {
            TabView(selection: $viewModel.currentBundle) {
                ForEach($viewModel.bundles) { $bundle in
                    OverlayCardView(cardAndStories: $bundle)
                        .environmentObject(viewModel)
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
                                viewModel.showOverlay = false
                            }
                        } else {
                            withAnimation {
                                viewModel.showOverlay = true
                            }
                        }
                        withAnimation {
                            offset = .zero
                            fade = false
                        }
                    }
            )
        }
    }
}
