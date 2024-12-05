//
//  StoryView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 30/03/24.
//

import SwiftUI

struct StoryView: View {
    @EnvironmentObject var viewModel: StoryViewModel

    @State private var offset = CGSize.zero
    @State private var fade: Bool = false

    var body: some View {


        if viewModel.showStory {
            TabView(selection: $viewModel.currentStory) {
                //stories
                ForEach($viewModel.stories) { $stories in
                    StoryCardView(storiesBundle: $stories)
                        .environmentObject(viewModel)
                }
            }


            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.black)
            .opacity(fade ? 0.3 : 1)

            //dismissing
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
                            // Swipe down detected, trigger dismiss with animation
                            withAnimation {
                                viewModel.showStory = false
                            }
                        } else {
                            withAnimation {
                                viewModel.showStory = true
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
