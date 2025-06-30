//
//  APIService.swift
//  Restaurant
//
//  Created by Mohit Tomar on 14/06/25.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case requestFailed(Error)
    case decodingFailed(Error)
    case serverError(statusCode: Int, message: String)
}

class APIService {
    static let shared = APIService()
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://uat.onebanc.ai/emulator/interview/"

    private func createRequest(for endpoint: String, method: String = "POST", body: Data?) -> URLRequest? {
        guard let url = URL(string: baseURL + endpoint) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("uonebancservceemultrS3cg8RaL30", forHTTPHeaderField: "X-Partner-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        // Extract forward proxy action from endpoint name
        let action = endpoint
        request.addValue(action, forHTTPHeaderField: "X-Forward-Proxy-Action")
        
        return request
    }

    func fetch<T: Decodable>(endpoint: String, body: [String: Any]? = nil) -> Future<T, APIError> {
        return Future { promise in
            let requestBody = body != nil ? try? JSONSerialization.data(withJSONObject: body!) : nil
            
            guard let request = self.createRequest(for: endpoint, body: requestBody) else {
                promise(.failure(.invalidURL))
                return
            }

            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { data, response -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        // Ideally parse an error model from the `data`
                        throw APIError.serverError(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500, message: "Server Error")
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .sink(receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        promise(.failure(.decodingFailed(error)))
                    }
                }, receiveValue: { response in
                    print("\n   response ",response)
                    promise(.success(response))
                })
                .store(in: &self.cancellables)
        }
    }
}

// Example API Response Wrapper
struct GetItemListResponse: Codable {
    let cuisines: [Cuisine]
}

struct GetItemByFilterResponse: Codable {
    let cuisines: [Cuisine]
}
