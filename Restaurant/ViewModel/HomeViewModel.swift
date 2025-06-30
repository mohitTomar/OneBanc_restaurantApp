//
//  HomeViewModel.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var cuisineCategories: [Cuisine] = []
    @Published var topRatedDishes: [Item] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    func fetchData() {
        isLoading = true
        fetchCuisineCategories()
        fetchTopRatedDishes()
    }
    
    private func fetchCuisineCategories() {
        let requestBody = ["page": 1, "count": 10]
        APIService.shared.fetch(endpoint: "get_item_list", body: requestBody)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] (response: GetItemListResponse) in
                self?.cuisineCategories = response.cuisines
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }

    private func fetchTopRatedDishes() {
        let requestBody: [String: Any] = ["min_rating": 4]
        APIService.shared.fetch(endpoint: "get_item_by_filter", body: requestBody)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                 if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] (response: GetItemByFilterResponse) in
                // Flatten all items from various cuisines and take the top 3
                let allItems = response.cuisines.flatMap { $0.items ?? [] }
                self?.topRatedDishes = Array(allItems.prefix(3))
            })
            .store(in: &cancellables)
    }
}
