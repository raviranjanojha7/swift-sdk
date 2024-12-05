//
//  MainView.swift
//  Insta-bundles
//
//  Created by Ravi Ranjan Ojha on 01/04/24.
//

import SwiftUI

public struct MainView: View {

    @StateObject private var viewModel = OverlayViewModel()

     public init(viewModel: OverlayViewModel = OverlayViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {

        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    //showing bundles
                    HStack {

                        //bundles
                        ForEach($viewModel.bundles) { $bundles in
                            //ProfleView
                            StoryView(bundles: $bundles)
                                .environmentObject(viewModel)
                        }
                    }
                    .padding(.leading)

                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        
                        
                        ForEach($viewModel.bundles) { $bundles in
                            //ProfleView
                            CardView(bundles: $bundles)
                                .environmentObject(viewModel)
                        }

                    }
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
