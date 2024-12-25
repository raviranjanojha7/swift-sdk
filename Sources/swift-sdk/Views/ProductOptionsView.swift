//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 25/12/24.
//

import SwiftUI

struct ProductOptionsView: View {
    let options: [ProductOptionWithValues]
    @State private var selectedValues: [String: String] = [:]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(options) { option in
                VStack(alignment: .leading, spacing: 8) {
                    Text(option.name)
                        .font(.system(size: 14, weight: .bold))
                    
                    Menu {
                        ForEach(option.values, id: \.self) { value in
                            Button(action: {
                                selectedValues[option.name] = value
                            }) {
                                Text(value)
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedValues[option.name] ?? "Select \(option.name)")
                                .font(.system(size: 14))
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

//#Preview {
//    ProductOptionsView()
//}
