//
//  Cuisine.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation

struct Cuisine: Codable, Identifiable, Hashable {
    var id: String { _cuisineId.wrappedValue }
    
    @GenericID var cuisineId: String
    let cuisineName: String
    let cuisineImageUrl: URL?
    let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case cuisineId = "cuisine_id"
        case cuisineName = "cuisine_name"
        case cuisineImageUrl = "cuisine_image_url"
        case items
    }
}

struct Item: Codable, Identifiable, Hashable {
    @GenericID var id: String
    let name: String
    let imageUrl: URL?
    let price: String? // Price can be string or number in different APIs
    let rating: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case imageUrl = "image_url"
        case price, rating
    }
}
