//
//  TopDishesView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

//
//  TopDishesView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI

struct TopDishesView: View {
    let dishes: [Item]
    @ObservedObject private var cartManager = CartManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared // Observe the shared instance

    var body: some View {
        VStack(alignment: .leading) {
            Text(localizationManager.localizedString(key: "top_rated_dishes"))
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(dishes) { dish in
                        DishTileView(dish: dish)
                    }
                }
                .padding()
            }
        }
    }
}

struct DishTileView: View {
    let dish: Item
    @ObservedObject private var cartManager = CartManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared // Observe the shared instance

    // Get the quantity for this specific dish from the cart manager
    private var quantity: Int {
        cartManager.cartItems[dish] ?? 0
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            AsyncImage(url: dish.imageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 100)
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .frame(width: 150, height: 100)
            }
            .cornerRadius(10)
            
            // Name and Price
            Text(dish.name)
                .font(.headline)
            
            HStack {
                Text("₹\(dish.price ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
                if let rating = dish.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(rating)
                    }
                    .font(.caption)
                }
            }
            
            // Add to cart button/stepper
            if quantity == 0 {
                Button(action: {
                    cartManager.add(item: dish)
                }) {
                    Text(localizationManager.localizedString(key: "Add_2"))
                        .font(.caption.bold())
                        .padding(.vertical, 6)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.accentColor)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.accentColor, lineWidth: 1))
                }
            } else {
                HStack {
                    Button(action: { cartManager.remove(item: dish) }) {
                        Image(systemName: "minus")
                    }
                    .padding(8)

                    Text("\(quantity)")
                        .bold()
                        .frame(minWidth: 20)

                    Button(action: { cartManager.add(item: dish) }) {
                        Image(systemName: "plus")
                    }
                    .padding(8)
                }
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
        }
        .frame(width: 150)
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 3)
    }
}
