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
                    // Product Image
                    AsyncImage(url: URL(string: product.images.first?.url ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                    
                    // Product Info
                    VStack(alignment: .leading, spacing: 12) {
                        Text(product.title)
                            .font(.system(size: 20, weight: .bold))
                        
                        HStack(spacing: 8) {
                            Text("₹\(product.price_min)")
                                .font(.system(size: 18, weight: .bold))
                            
                            if let comparePrice = Double(product.compare_at_price_max_number),
                               comparePrice > 0 {
                                Text("₹\(product.compare_at_price_max_number)")
                                    .font(.system(size: 16))
                                    .strikethrough()
                                    .foregroundColor(.gray)
                                
                                let discount = Int(((comparePrice - Double(product.price_min)!) / comparePrice) * 100)
                                Text("\(discount)% off")
                                    .font(.system(size: 14))
                                    .foregroundColor(.green)
                            }
                        }
                        
                        Text(product.description)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
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

//#Preview {
//    ProductDetailSheet(product: MediaProduct(id: 1, title: "Sample Product", price_min: 100, compare_at_price_max_number: 150, description: "This is a sample product description.", images: [MediaImage(id: 1, url: "https://example.com/image1.jpg")]))
//}
