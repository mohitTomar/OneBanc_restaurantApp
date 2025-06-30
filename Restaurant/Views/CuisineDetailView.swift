//
//  CuisineDetailView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI


struct CuisineDetailView: View {
    @StateObject private var viewModel: CuisineDetailViewModel
    @ObservedObject private var cartManager = CartManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared // Observe the shared instance

    init(cuisineName: String) {
        _viewModel = StateObject(wrappedValue: CuisineDetailViewModel(cuisineName: cuisineName))
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
            } else {
                List {
                    ForEach(viewModel.dishes) { dish in
                        HStack {
                            AsyncImage(url: dish.imageUrl) { image in
                                image.resizable().aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(dish.name)
                                Text("₹\(dish.price ?? "0")")
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                cartManager.add(item: dish)
                            }) {
                                Text(localizationManager.localizedString(key: "Add_1"))
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.cuisineName)
        .onAppear {
            viewModel.fetchData()
        }
    }
}
