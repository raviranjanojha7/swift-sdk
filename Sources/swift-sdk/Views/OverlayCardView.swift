//
//  OverlayCardView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct OverlayCardView: View {

    @Binding var cardAndStories: CardAndStoryBundle
    @EnvironmentObject var viewModel: OverlayViewModel

    //Timer and Changing Based on Timer
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    //Progress
    @State var timerProgress: CGFloat = .zero

    // Add this to force view refresh when story changes
    @State private var currentStoryIndex: Int = 0

    public init(cardAndStories: Binding<CardAndStoryBundle>) {
        self._cardAndStories = cardAndStories
    }

    public var body: some View {

        //for 3d Rotation
        GeometryReader { proxy in
            ZStack {

                //Getting current Index
                //And updating data
                let index = min(Int(timerProgress), cardAndStories.medias.count - 1)

                let overlayMedia = cardAndStories.medias[index]
                if overlayMedia.isVideo {
                    VideoPlayer(url: URL(string: overlayMedia.mediaURL))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .id("video_\(index)") // Add unique ID to force view refresh
                } else {
                    AsyncImage(url: URL(string: overlayMedia.mediaURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            Image(systemName: "photo")
                                .resizable()
                        case .empty:
                            ProgressView()
                        @unknown default:
                            ProgressView()
                        }
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.black)
            .ignoresSafeArea()

            //tapping
            .overlay(
                HStack {
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if (timerProgress - 1) < 0 {
                                //update to next
                                updateOverlay(forward: false)
                            } else {
                                timerProgress = CGFloat(Int(timerProgress - 1))
                            }
                        }

                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if (timerProgress + 1) > CGFloat(cardAndStories.medias.count) {
                                //update to next
                                updateOverlay()
                            } else {
                                timerProgress = CGFloat(Int(timerProgress + 1))
                            }
                        }
                }
            )
            //Top Timer Capsule
            .overlay(
                OverlayTopIndicator(bundle: $cardAndStories, timerProgress: $timerProgress)
                    .frame(height: 1.4)
                    .padding(.horizontal)
                ,alignment: .top
            )
            .overlay(Button {
                viewModel.currentBundle = ""
                viewModel.showOverlay = false
                    } label: {
                        XDismissButton().padding(.top, 5)
                    }, alignment: .topTrailing
            )

            //rotation
            .rotation3DEffect(
                getAngle(proxy: proxy),
                axis: (x: 0, y: 1, z: 0),
                anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                perspective: 2.5
            )
        }

        //reseting timer
        .onAppear(perform: {
            timerProgress = 0
            currentStoryIndex = 0
        })

        .onReceive(timer, perform: { _ in
            //updating timer
            if viewModel.currentBundle == cardAndStories.id {
                if timerProgress < CGFloat(cardAndStories.medias.count) - 1 {
                    timerProgress += 0.02
                    // Update currentStoryIndex when story changes
                    let newIndex = min(Int(timerProgress), cardAndStories.medias.count - 1)
                    if currentStoryIndex != newIndex {
                        currentStoryIndex = newIndex
                    }
                } else {
                    if timerProgress < CGFloat(cardAndStories.medias.count) {
                        timerProgress += 0.02
                    } else {
                        updateOverlay()
                    }
                }
            }
        })
    }

    //updating on End
    private func updateOverlay(forward: Bool = true) {
        withAnimation(.easeInOut) {
            if forward {
                if let nextID = viewModel.nextBundleID(currentID: viewModel.currentBundle) {
                    // There's a next story, so update the current story to it.
                    viewModel.currentBundle = nextID
                    // Reset progress when moving to next story
                    timerProgress = 0
                    currentStoryIndex = 0
                } else {
                    // There's no next story, indicating this is the last one. Hide the story view.
                    viewModel.showOverlay = false
                }
            } else {
                if let prevID = viewModel.previousBundleID(currentID: viewModel.currentBundle) {
                    // There's a previous story, so update the current story to it.
                    viewModel.currentBundle = prevID
                    // Reset progress when moving to previous story
                    timerProgress = 0
                    currentStoryIndex = 0
                } else {
                    // Optionally, handle if you're at the first story and attempting to go back further,
                    // which might not change the visibility but could reset to a default view or perform another action.
                }
            }
        }
    }

    private func getAngle(proxy: GeometryProxy) -> Angle {
        //converting offset into 45 deg
        let progress = proxy.frame(in: .global).minX / proxy.size.width

        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
}



#Preview {
    OverlayCardView(cardAndStories:  .constant(CardAndStoryBundle(
        profileName: "Canada",
        medias: [
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_rc2jan2cq4z130ey73re7bau.mp4", isVideo: true),
            CardAndStory(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: false),
        ]
    ))).environmentObject(OverlayViewModel())
}
