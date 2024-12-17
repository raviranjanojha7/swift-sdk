//
//  OverlayTopIndicator.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI

struct OverlayTopIndicator: View {
    let mediaItem: PlaylistMediaItem
    @ObservedObject var viewModel: OverlayViewModel
    @State var timerProgress: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 5) {
            if mediaItem.type == .media {
                // Single progress bar for media type
                progressBar(progress: timerProgress)
            } else if mediaItem.type == .group, let group = mediaItem.group {
                // Multiple progress bars for group type
                ForEach(0..<group.medias.count, id: \.self) { index in
                    progressBar(progress: index <= viewModel.groupMediaIndex ? 1 : 0)
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 2)
    }
    
    private func progressBar(progress: CGFloat) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            Capsule()
                .fill(.gray.opacity(0.5))
                .frame(height: 2)
                .overlay(
                    Capsule()
                        .fill(.white)
                        .frame(width: width * progress, height: 2)
                        .animation(.interactiveSpring(duration: 0.1), value: progress),
                    alignment: .leading
                )
        }
    }
}



