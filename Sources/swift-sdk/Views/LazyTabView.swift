//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 17/12/24.
//

import SwiftUI

struct LazyTabView<Content: View>: View {
    let count: Int
    @Binding var selection: Int
    let content: (Int) -> Content
    
    init(count: Int, selection: Binding<Int>, @ViewBuilder content: @escaping (Int) -> Content) {
        self.count = count
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(visibleIndices, id: \.self) { index in
                content(index)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var visibleIndices: [Int] {
        let currentIndex = selection
        let indices = (currentIndex - 1...currentIndex + 1).filter { $0 >= 0 && $0 < count }
        return Array(indices)
    }
}


