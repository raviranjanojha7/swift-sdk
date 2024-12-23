//
//  File.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 23/12/24.
//

import Foundation
import SwiftUI

struct ProductInfoView: View {
    let product: MediaProduct
    
    private var discountPercentage: Int? {
        guard let comparePrice = Double(product.compare_at_price_min_number),
              let price = Double(product.price_min_number),
              comparePrice > 0 else { return nil }
        
        let discount = ((comparePrice - price) / comparePrice) * 100
        return Int(discount)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Product Image
            AsyncImage(url: URL(string: product.images.first?.url ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 60)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Product Info
            Text(product.title.split(separator: "|").first?.trimmingCharacters(in: .whitespaces) ?? product.title)
                .font(.system(size: 12))
                .lineLimit(1)
                .foregroundColor(.black)
            
            HStack(spacing: 4) {
                Text("₹\(product.price_min)")
                    .font(.system(size: 12, weight: .bold))
                
                if let discount = discountPercentage {
                    Text("\(discount)% off")
                        .font(.system(size: 10))
                        .foregroundColor(.green)
                }
            }
        }
        .padding(8)
        .frame(width: 153)
        .background(Color.white)
    }
}
