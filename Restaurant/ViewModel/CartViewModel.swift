//
//  CartViewModel.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation
import Combine
import SwiftUICore

class CartViewModel: ObservableObject {
    @ObservedObject var cartManager = CartManager.shared
    @Published var orderStatusMessage: String?
    @Published var isPlacingOrder = false

    var netTotal: Double { cartManager.netTotal }
    var cgst: Double { netTotal * 0.025 }
    var sgst: Double { netTotal * 0.025 }
    var grandTotal: Double { netTotal + cgst + sgst }

    private var cancellables = Set<AnyCancellable>()

    func placeOrder() {
        isPlacingOrder = true
        // Construct the request body for make_payment API
        // This requires mapping cart items to cuisine_id, which might need extra logic
        // For simplicity, we'll send a placeholder body.
        let body: [String: Any] = [
            "total_amount": String(format: "%.2f", grandTotal),
            "total_items": cartManager.totalItemCount,
            "data": [] // Needs to be populated correctly
        ]
        
        APIService.shared.fetch(endpoint: "make_payment", body: body)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isPlacingOrder = false
                if case .failure = completion {
                    self?.orderStatusMessage = "Failed to place order."
                }
            }, receiveValue: { [weak self] (response: MakePaymentResponse) in
                self?.orderStatusMessage = "\(response.responseMessage). Ref: \(response.txnRefNo)"
                // Clear cart on successful order
            })
            .store(in: &cancellables)
    }
}

struct MakePaymentResponse: Codable {
    let responseMessage: String
    let txnRefNo: String
    enum CodingKeys: String, CodingKey {
        case responseMessage = "response_message"
        case txnRefNo = "txn_ref_no"
    }
}
