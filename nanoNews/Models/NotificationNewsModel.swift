//
//  NotificationNewsModel.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import Foundation

struct NotificationNewsModel: Codable, Identifiable {
    let id: Int
    let category: String
    let title: String
    let summary: String
    let source: String
    let sourceURL: String
    let imageURL: String?
    let publishedAt: Date
    let isBreaking: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case category
        case title
        case summary
        case source
        case sourceURL = "source_url"
        case imageURL = "image_url"
        case publishedAt = "published_at"
        case isBreaking = "is_breaking"
    }
}
