//
//  NetworkManager.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import Foundation
import UIKit

class NetworkManager {

    static let shared = NetworkManager()
    private init() {}

    // MARK: - Fetch News Notifications For Category ------------------------------------
    func fetchCategoryNotifications(
        category: String,
        offset: Int = 0,
        limit: Int = 20,
        completion: @escaping (Result<[NotificationNewsModel], Error>) -> Void
    ) {
        
        let urlString = "\(Constants.API.baseURL)category_notifications/"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(
                NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            ))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        // Auth
//        if let token = AuthManager.shared.getToken() {
//            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        } else {
//            completion(.failure(
//                NSError(domain: "", code: -1,
//                        userInfo: [NSLocalizedDescriptionKey: "No authentication token found"])
//            ))
//            return
//        }

        // Request Body
        let body: [String: Any] = [
            "category": category,
            "offset": offset,
            "limit": limit
        ]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body)
            request.httpBody = jsonData

            request.addValue("\(jsonData.count)", forHTTPHeaderField: "Content-Length")

            if let host = url.host {
                request.addValue(host, forHTTPHeaderField: "Host")
            }

        } catch {
            completion(.failure(
                NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to encode request body"])
            ))
            return
        }

        // Network Request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(
                    NSError(domain: "", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "No data"])
                ))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let result = try decoder.decode([NotificationNewsModel].self, from: data)
                completion(.success(result))

            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
