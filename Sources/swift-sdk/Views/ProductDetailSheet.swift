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
    @ObservedObject var viewModel: OverlayViewModel
    
    private var currentProduct: MediaProduct {
        viewModel.selectedProduct ?? product
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ProductImagesSection(currentProduct: currentProduct)
                    ProductInfoSection(currentProduct: currentProduct)
                    Divider()
                        .background(Color.gray.opacity(0.2))
                        .frame(height: 4)
                        .padding(.horizontal)
                    ProductListSection(viewModel: viewModel)
                    ProductDescriptionSection(currentProduct: currentProduct)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    CloseButton(dismiss: dismiss)
                }
            }
        }
    }
}

// MARK: - Subviews
private struct ProductImagesSection: View {
    let currentProduct: MediaProduct
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(currentProduct.images, id: \.url) { image in
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
    }
}

private struct ProductInfoSection: View {
    let currentProduct: MediaProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(currentProduct.title)
                .font(.system(size: 18, weight: .bold))
            
            PriceView(currentProduct: currentProduct)
            
            if !currentProduct.options_with_values.isEmpty {
                let options = currentProduct.options_with_values.map { option in
                    ProductOptionWithValues(
                        id: option.id,
                        name: option.name,
                        values: option.values
                    )
                }
                
                ProductOptionsView(options: options)
                    .padding(.top, 8)
            }
        }
        .padding(.horizontal)
    }
}

private struct PriceView: View {
    let currentProduct: MediaProduct
    
    var body: some View {
        HStack(spacing: 8) {
            Text("₹\(currentProduct.price_min)")
                .font(.system(size: 14, weight: .bold))
            
            if let comparePrice = Double(currentProduct.compare_at_price_max_number),
               let price = Double(currentProduct.price_min),
               comparePrice > price {
                Text("₹\(currentProduct.compare_at_price_max_number)")
                    .font(.system(size: 14))
                    .strikethrough()
                    .foregroundColor(.gray)
                
                let discount = Int(((comparePrice - price) / comparePrice) * 100)
                Text("\(discount)% off")
                    .font(.system(size: 14))
                    .foregroundColor(.green)
            }
        }
    }
}

private struct ProductListSection: View {
    @ObservedObject var viewModel: OverlayViewModel
    
    var body: some View {
        Group {
            if let playlist = viewModel.playlist,
               let currentMedia = playlist.media[safe: viewModel.activeIndex],
               let products = currentMedia.type == .media ? currentMedia.media?.products : currentMedia.group?.medias[viewModel.groupMediaIndex].products,
               products.count > 1 {
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Product")
                        .font(.system(size: 14, weight: .bold))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(products, id: \.id) { item in
                                ProductThumbnail(
                                    product: item,
                                    isSelected: viewModel.selectedProduct?.id == item.id
                                ) {
                                    viewModel.selectedProduct = item
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                Divider()
                    .background(Color.gray.opacity(0.2))
                    .frame(height: 4)
                    .padding(.horizontal)
            }
        }
    }
}

private struct ProductDescriptionSection: View {
    let currentProduct: MediaProduct
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Description")
                .font(.system(size: 14, weight: .bold))
            ExpandableText(text: currentProduct.description)
        }
        .padding(.horizontal)
    }
}

private struct CloseButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .foregroundColor(.black)
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

// Add this new view for product thumbnails
struct ProductThumbnail: View {
    let product: MediaProduct
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                AsyncImage(url: URL(string: product.images.first?.url ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                )
                
                Text(product.title.split(separator: "|").first?.trimmingCharacters(in: .whitespaces) ?? product.title)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundColor(.black)
            }
            .frame(width: 80)
        }
    }
}


