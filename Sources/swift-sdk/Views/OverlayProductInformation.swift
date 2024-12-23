//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 23/12/24.
//

import SwiftUI

struct OverlayProductInformation: View {
    let product: MediaProduct
    @State private var showingProductSheet = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Product Image
            AsyncImage(url: URL(string: product.images.first?.url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 48, height: 48)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Product Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title.split(separator: "|").first?.trimmingCharacters(in: .whitespaces) ?? product.title)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                    .foregroundColor(.black)
                
                HStack(spacing: 4) {
                    Text("₹\(product.price_min)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.black)
                    
                    if let comparePrice = Double(product.compare_at_price_max_number),
                       comparePrice > 0 {
                        Text("₹\(product.compare_at_price_max_number)")
                            .font(.system(size: 12))
                            .strikethrough()
                            .foregroundColor(.black)
                    }
                }
            }
            
            Spacer()
            
            // Shop Now Button
            Button(action: {
                showingProductSheet = true
            }) {
                Text("Shop Now")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.black)
                    .cornerRadius(8)
            }
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
        .sheet(isPresented: $showingProductSheet) {
            ProductDetailSheet(product: product)
                .presentationDetents([.fraction(0.8)]) // Makes sheet cover 4/5 of screen
        }
    }
}

//#Preview {
//    OverlayProductInformation(product: MediaProduct(title: "Product Title", price_min: "100", compare_at_price_max_number: "150"))
//}
