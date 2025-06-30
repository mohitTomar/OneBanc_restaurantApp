//
//  RestaurantApp.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import SwiftUI

@main
struct RestaurantAppApp: App {
    // Initialize the shared LocalizationManager once
    @StateObject private var localizationManager = LocalizationManager.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(localizationManager) // Make LocalizationManager available to all subviews
        }
    }
}
