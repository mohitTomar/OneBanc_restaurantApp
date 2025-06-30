//
//  CartView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI

struct CartView: View {
    @StateObject private var viewModel = CartViewModel()
    @ObservedObject private var localizationManager = LocalizationManager.shared // Observe the shared instance

    var body: some View {
        VStack {
            List {
                ForEach(viewModel.cartManager.cartItems.keys.sorted(by: { $0.name < $1.name }), id: \.self) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        Text("Qty: \(viewModel.cartManager.cartItems[item] ?? 0)")
                        Text("₹\(item.price ?? "0")")
                    }
                }
            }
            
            Spacer()
            
            // Totals Section
            VStack(spacing: 8) {
                HStack { Text(localizationManager.localizedString(key: "Net_Total")); Spacer(); Text(String(format: "₹%.2f", viewModel.netTotal)) }
                HStack { Text("CGST (2.5%)"); Spacer(); Text(String(format: "₹%.2f", viewModel.cgst)) }
                HStack { Text("SGST (2.5%)"); Spacer(); Text(String(format: "₹%.2f", viewModel.sgst)) }
                Divider()
                HStack { Text(localizationManager.localizedString(key: "Grand_Total")).bold(); Spacer(); Text(String(format: "₹%.2f", viewModel.grandTotal)).bold() }
            }
            .padding()
            
            // Place Order Button
            Button(action: {
                viewModel.placeOrder()
            }) {
                Text(viewModel.isPlacingOrder ?  localizationManager.localizedString(key: "Placing_order") : localizationManager.localizedString(key: "Place_order"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(viewModel.isPlacingOrder || viewModel.cartManager.cartItems.isEmpty)
        }
        .navigationTitle(localizationManager.localizedString(key: "Your Cart"))
        .alert(item: $viewModel.orderStatusMessage) { message in
            Alert(title: Text("Order Status"), message: Text(message), dismissButton: .default(Text("OK")))
        }
    }
}

// For using String in .alert
extension String: Identifiable {
    public var id: String { self }
}
