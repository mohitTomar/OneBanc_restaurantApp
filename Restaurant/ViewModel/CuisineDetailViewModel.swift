//
//  CuisineDetailViewModel.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI
import Combine

class CuisineDetailViewModel: ObservableObject {
    @Published var dishes: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    let cuisineName: String

    init(cuisineName: String) {
        self.cuisineName = cuisineName
    }

    func fetchData() {
        isLoading = true
        fetchDishes(cuisineName: cuisineName)
    }

    private func fetchDishes(cuisineName: String) {
        let requestBody: [String: Any] = ["cuisine_type": [cuisineName]]
        APIService.shared.fetch(endpoint: "get_item_by_filter", body: requestBody)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] (response: GetItemByFilterResponse) in
                self?.dishes = response.cuisines.first?.items ?? []
            })
            .store(in: &cancellables)
    }
}
