//
//  SwiftUIView.swift
//  swift-sdk
//
//  Created by Ravi Ranjan  Ojha on 23/12/24.
//

import SwiftUI

struct ProductDetailSheet: View {
    let product: MediaProduct
    let media: PlaylistMediaItemWithProducts
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: OverlayViewModel
    
    private var currentProduct: MediaProduct {
        viewModel.selectedProduct ?? product
    }
    
    private var isProductAvailable: Bool {
        if let selectedVariant = viewModel.selectedVariant {
            return currentProduct.available && selectedVariant.available
        }
        return currentProduct.available
    }
    
    private func handleAddToCart() {
        if let productId = viewModel.selectedProduct?.id,
           let variantId = viewModel.selectedVariant?.id,
           let productPrice = viewModel.selectedProduct?.price_min {
            Task {
                await EventsManager.shared.addToCart(
                    productId: productId,
                    variantId: variantId,
                    productPrice: productPrice
                )
            }
        }
        viewModel.addToCart()
    }
    
    private func handleMoreInfo() {
        if let mediaId = media.media?.id ??
            media.group?.id  {
            Task {
                 EventsManager.shared.ctaClicked(
                    playlistId: viewModel.playlistId,
                    mediaId: mediaId,
                    widgetType: viewModel.widgetType,
                    ctaTitle: media.media?.ctatitle ?? "",
                    ctaLink: media.media?.ctalink ?? "",
                    index: viewModel.activeIndex,
                    subIndex: viewModel.groupMediaIndex
                )
            }
        }
        viewModel.redirectToProduct()
    }
    
    private var bottomButtons: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 16) {
                moreInfoButton
                addToCartButton
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: -2)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private var moreInfoButton: some View {
        Button(action: handleMoreInfo) {
            Text("More Info")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
        }
    }
    
    private var addToCartButton: some View {
        Button(action: handleAddToCart) {
            Text(isProductAvailable ? "Add to cart" : "Out of stock")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(isProductAvailable ? Color.black : Color.gray)
                .cornerRadius(8)
        }
        .disabled(!isProductAvailable)
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ProductImagesSection(currentProduct: currentProduct)
                        ProductInfoSection(currentProduct: currentProduct, viewModel: viewModel)
                        Divider()
                            .background(Color.gray.opacity(0.2))
                            .frame(height: 4)
                            .padding(.horizontal)
                        ProductListSection(viewModel: viewModel)
                        ProductDescriptionSection(currentProduct: currentProduct)
                    }
                    .padding(.bottom, 80)
                }
                
                bottomButtons
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
    @ObservedObject var viewModel: OverlayViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(currentProduct.title)
                .font(.system(size: 18, weight: .bold))
            
            PriceView(currentProduct: currentProduct, viewModel: viewModel)
            
            if !currentProduct.options_with_values.isEmpty {
                let options = currentProduct.options_with_values.map { option in
                    ProductOptionWithValues(
                        id: option.id,
                        name: option.name,
                        values: option.values
                    )
                }
                
                ProductOptionsView(options: options, variants: currentProduct.variants, viewModel: viewModel)
                    .padding(.top, 8)
            }
        }
        .padding(.horizontal)
    }
}

private struct PriceView: View {
    let currentProduct: MediaProduct
    @ObservedObject var viewModel: OverlayViewModel
    
    private var priceToShow: String {
        if let variant = viewModel.selectedVariant,
           !variant.price.isEmpty {
            return variant.price
        }
        return currentProduct.price_min
    }
    
    private var comparePriceToShow: String {
        if let variant = viewModel.selectedVariant,
           !variant.compare_at_price.isEmpty {
            return variant.compare_at_price
        }
        return currentProduct.compare_at_price_max_number
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Text("₹\(priceToShow)")
                .font(.system(size: 14, weight: .bold))
            
            if let comparePrice = Double(comparePriceToShow),
               let price = Double(priceToShow),
               comparePrice > price {
                Text("₹\(comparePriceToShow)")
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
    
    private func getProducts() -> [MediaProduct]? {
        guard let playlist = viewModel.playlist,
              let currentMedia = playlist.media[safe: viewModel.activeIndex] else {
            return nil
        }
        
        let products = currentMedia.type == .media ? 
            currentMedia.media?.products : 
            currentMedia.group?.medias[viewModel.groupMediaIndex].products
        
        if let productCount = products?.count, productCount > 1 {
            return products
        }
        return nil
    }
    
    private func trackProductView(for product: MediaProduct) {
        let mediaId = viewModel.playlist?.media[safe: viewModel.activeIndex]?.media?.id ?? 
                     viewModel.playlist?.media[safe: viewModel.activeIndex]?.group?.id ?? ""
                     
        EventsManager.shared.productViewed(
            playlistId: viewModel.playlistId,
            mediaId: mediaId,
            widgetType: viewModel.widgetType,
            activeIndex: viewModel.activeIndex,
            groupMediaIndex: viewModel.groupMediaIndex,
            produdctId: product.id,
            productHandle: product.handle,
            variantId: product.variants[0].id
        )
    }
    
    var body: some View {
        Group {
            if let products = getProducts() {
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
                                    trackProductView(for: item)
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


