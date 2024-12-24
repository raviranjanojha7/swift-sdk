//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 23/12/24.
//

import SwiftUI

struct ProductDetailSheet: View {
    let product: MediaProduct
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(product.images, id: \.url) { image in
                                AsyncImage(url: URL(string: image.url)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 232, height: 232)
                                        .clipped()
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 232, height: 232)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            }
                        }.padding(.leading, 5)
                    }
                    
                    // Product Info
                    VStack(alignment: .leading, spacing: 14) {
                        Text(product.title)
                            .font(.system(size: 18, weight: .bold))
                        
                        HStack(spacing: 8) {
                            Text("₹\(product.price_min)")
                                .font(.system(size: 14, weight: .bold))
                            
                            if let comparePrice = Double(product.compare_at_price_max_number),
                               let price = Double(product.price_min),
                               comparePrice > price {
                                Text("₹\(product.compare_at_price_max_number)")
                                    .font(.system(size: 14))
                                    .strikethrough()
                                    .foregroundColor(.gray)
                                
                                let discount = Int(((comparePrice - Double(product.price_min)!) / comparePrice) * 100)
                                Text("\(discount)% off")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.system(size: 14, weight: .bold))
                            ExpandableText(text: product.description)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct ExpandableText: View {
    let text: String
    @State private var isExpanded = false
    @State private var isTruncated = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.system(size: 12))
                .lineLimit(isExpanded ? nil : 4)
                .background(
                    GeometryReader { geometry in
                        Color.clear.onAppear {
                            let totalLines = Int(geometry.size.height / 14) 
                            self.isTruncated = totalLines > 3
                        }
                    }
                )
            
            if isTruncated {
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Text(isExpanded ? "Read less" : "Read more")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
        }
    }
}


