//
//  LocalizationManager.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation
import Combine

class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager() // Singleton instance

    @Published var currentLanguage: String {
        didSet {
            // Save the selected language to UserDefaults
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            // Notify SwiftUI views to re-render
            objectWillChange.send()
        }
    }

    private var bundle: Bundle?

    private init() {
        // Load the previously saved language or default to English
        self.currentLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        setLanguage(languageCode: self.currentLanguage) // Ensure the bundle is set up initially
    }

    /// Sets the application's language and updates the bundle.
    /// - Parameter languageCode: The language code (e.g., "en", "hi").
    func setLanguage(languageCode: String) {
        // Ensure the language code is valid (e.g., "en", "hi")
        if let path = Bundle.main.path(forResource: languageCode, ofType: "lproj"),
           let newBundle = Bundle(path: path) {
            self.bundle = newBundle
            self.currentLanguage = languageCode
            print("Language set to: \(languageCode)")
        } else {
            // Fallback to default if the language is not found
            print("Warning: Language bundle not found for \(languageCode). Falling back to default.")
            if let defaultPath = Bundle.main.path(forResource: "en", ofType: "lproj"),
               let defaultBundle = Bundle(path: defaultPath) {
                self.bundle = defaultBundle
                self.currentLanguage = "en" // Set to English if no valid language found
            } else {
                // If even the default English bundle isn't found, use main bundle
                self.bundle = Bundle.main
                self.currentLanguage = "en"
            }
        }
    }

    /// Returns the localized string for a given key.
    /// - Parameters:
    ///   - key: The key for the localized string.
    ///   - comment: An optional comment for clarity.
    /// - Returns: The localized string, or the key if not found.
    func localizedString(key: String, comment: String = "") -> String {
        // Use the specific bundle if available, otherwise use the main bundle
        return bundle?.localizedString(forKey: key, value: key, table: nil) ?? key
    }
}
