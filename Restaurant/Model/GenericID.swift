//
//  GenericID.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation

// A property wrapper to decode values that can be either Int or String into a String.
@propertyWrapper
struct GenericID: Codable, Hashable {
    var wrappedValue: String

    init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            wrappedValue = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            wrappedValue = stringValue
        } else {
            throw DecodingError.typeMismatch(GenericID.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected Int or String but found neither"))
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
