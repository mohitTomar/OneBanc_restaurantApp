//
//  HomeView.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @ObservedObject private var cartManager = CartManager.shared
    @ObservedObject private var localizationManager = LocalizationManager.shared // Observe the shared instance
    @State private var selectedCuisine: Cuisine?
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(localizationManager.localizedString(key: "error_message_prefix") + errorMessage)
                } else {
                    ScrollView {
                        // Functionality 1: Cuisine Categories
                        CuisineCarouselView(cuisines: viewModel.cuisineCategories, selectedCuisine: $selectedCuisine)
                        
                        // Functionality 2: Top 3 Dishes - NOW UNCOMMENTED
                        TopDishesView(dishes: viewModel.topRatedDishes)
                    }
                }
            }
            .navigationTitle(localizationManager.localizedString(key: "restaurant_title"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // Functionality 3: Cart Button
                    NavigationLink(destination: CartView()) {
                        Image(systemName: "cart.fill")
                            .overlay(
                                // BadgeView will now be found
                                BadgeView(count: cartManager.totalItemCount)
                            )
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    // Functionality 4: Language Selection
                    Menu {
                        Button("English") {
                            localizationManager.setLanguage(languageCode: "en")
                        }
                        Button("हिन्दी") { // Hindi
                            localizationManager.setLanguage(languageCode: "hi")
                        }
                    } label: {
                        Image(systemName: "globe")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                }
            }
            .onAppear {
                viewModel.fetchData()
            }
            .sheet(item: $selectedCuisine) { cuisine in
                // On tap move to screen 2 - NOW UNCOMMENTED
                CuisineDetailView(cuisineName: cuisine.cuisineName)
            }
        }
    }
}

// Horizontal Infinite Scroll for Cuisines
struct CuisineCarouselView: View {
    let cuisines: [Cuisine]
    @Binding var selectedCuisine: Cuisine?
    
    var body: some View {
        TabView {
            ForEach(cuisines) { cuisine in
                CuisineCardView(cuisine: cuisine)
                    .padding(.horizontal, 10)
                    .onTapGesture {
                        self.selectedCuisine = cuisine
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 200)
    }
}

// Card for a single cuisine
struct CuisineCardView: View {
    let cuisine: Cuisine
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: cuisine.cuisineImageUrl) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fill)
                // Add .clipped() here to ensure the image doesn't overflow its own bounds
                    .clipped()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            // Ensure the image itself respects the frame of its parent ZStack
            .frame(height: 180) // Apply frame to AsyncImage directly
            .background(Color.secondary) // Apply background to AsyncImage if needed
            .clipShape(RoundedRectangle(cornerRadius: 15))
            
            VStack(alignment: .leading) {
                Text(cuisine.cuisineName)
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding()
            .background(LinearGradient(colors: [.clear, .black.opacity(0.7)], startPoint: .top, endPoint: .bottom))
        }
        .frame(height: 180)
        .background(Color.secondary)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    HomeView()
}
