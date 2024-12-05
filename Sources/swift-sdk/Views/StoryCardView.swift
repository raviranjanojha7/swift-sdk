//
//  StoryCardView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 05/12/24.
//

import SwiftUI

public struct StoryCardView: View {

    @Binding var storiesBundle: StoryBundle
    @EnvironmentObject var viewModel: StoryViewModel

    //Timer and Changing Based on Timer
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    //Progress
    @State var timerProgress: CGFloat = .zero

    public init(storiesBundle: Binding<StoryBundle>) {
        self._storiesBundle = storiesBundle
    }

    public var body: some View {

        //for 3d Rotation
        GeometryReader { proxy in
            ZStack {

                //Getting current Index
                //And updating data
                let index = min(Int(timerProgress), storiesBundle.stories.count - 1)

                let story = storiesBundle.stories[index]
                if story.isVideo {
                    VideoPlayer(url: URL(string: story.mediaURL))
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                } else {
                    AsyncImage(url: URL(string: story.mediaURL)) { phase in
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
                                updateStory(forward: false)
                            } else {
                                timerProgress = CGFloat(Int(timerProgress - 1))
                            }
                        }

                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if (timerProgress + 1) > CGFloat(storiesBundle.stories.count) {
                                //update to next
                                updateStory()
                            } else {
                                timerProgress = CGFloat(Int(timerProgress + 1))
                            }
                        }
                }
            )

            //Top Timer Capsule
            .overlay(
                StoryTopIndicator(storiesBundle: $storiesBundle, timerProgress: $timerProgress)
                    .frame(height: 1.4)
                    .padding(.horizontal)
                ,alignment: .top
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
        })

        .onReceive(timer, perform: { _ in
            //updating timer
            if viewModel.currentStory == storiesBundle.id {
                if timerProgress < CGFloat(storiesBundle.stories.count) - 1 {
                    timerProgress += 0.02
                } else {
                    if timerProgress < CGFloat(storiesBundle.stories.count) {
                        timerProgress += 0.02
                    } else {
                        updateStory()
                    }
                }
            }
        })
    }

    //updating on End
    private func updateStory(forward: Bool = true) {
        withAnimation(.easeInOut) {
            if forward {
                if let nextID = viewModel.nextStoryID(currentID: viewModel.currentStory) {
                    // There's a next story, so update the current story to it.
                    viewModel.currentStory = nextID
                } else {
                    // There's no next story, indicating this is the last one. Hide the story view.
                    viewModel.showStory = false
                }
            } else {
                if let prevID = viewModel.previousStoryID(currentID: viewModel.currentStory) {
                    // There's a previous story, so update the current story to it.
                    viewModel.currentStory = prevID
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
    StoryCardView(storiesBundle:  .constant(StoryBundle(
        profileName: "Canada",
        stories: [
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: true),
            Story(mediaURL: "https://www.boat-lifestyle.com/cdn/shop/files/quinn_zntjxmugklrk3vhl1fjxqr5g.mp4", isVideo: false),
        ]
    ))).environmentObject(StoryViewModel())
}
