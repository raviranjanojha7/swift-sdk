//
//  MainView.swift
//  Insta-Stories
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI

public struct MainView: View {

    @StateObject private var viewModel = StoryViewModel()

     public init(viewModel: StoryViewModel = StoryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {

        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    //showing stories
                    HStack(spacing: 12) {

                        //Stories
                        ForEach($viewModel.stories) { $stories in
                            //ProfleView
                            ProfileView(stories: $stories)
                                .environmentObject(viewModel)
                        }

                    }
                    .padding()
                }
            }
        }
        .overlay(
            OverlayView()
                .environmentObject(viewModel)
        )
    }
}

#Preview {
    MainView()
}
