//
//  CartManager.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation
import Combine

class CartManager: ObservableObject {
    static let shared = CartManager()
    
    @Published private(set) var cartItems: [Item: Int] = [:] // [Item: Quantity]
    
    var totalItemCount: Int {
        cartItems.values.reduce(0, +)
    }
    
    var netTotal: Double {
        cartItems.reduce(0.0) { total, itemTuple in
            let (item, quantity) = itemTuple
            let price = Double(item.price ?? "0") ?? 0.0
            return total + (price * Double(quantity))
        }
    }
    
    private init() {}
    
    func add(item: Item) {
        cartItems[item, default: 0] += 1
    }
    
    func remove(item: Item) {
        if let quantity = cartItems[item], quantity > 1 {
            cartItems[item] = quantity - 1
        } else {
            cartItems.removeValue(forKey: item)
        }
    }
}
