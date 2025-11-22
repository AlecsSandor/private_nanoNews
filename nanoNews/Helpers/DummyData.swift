//
//  DummyDataa.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import Foundation

// Helper to create a date easily
func makeDate(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 12, _ minute: Int = 0) -> Date {
    let calendar = Calendar.current
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    return calendar.date(from: components) ?? Date()
}

// Dummy data array
let dummyNews: [NotificationNewsModel] = [
    NotificationNewsModel(
        id: 1,
        category: "artificial_intelligence",
        title: "OpenAI Releases New Edge-Optimized Model",
        summary: "OpenAI introduced a lightweight model designed for fast on-device inference. Early tests show a 40% speed improvement while using less power.",
        source: "TechCrunch",
        sourceURL: "https://example.com/article/openai-model",
        imageURL: "https://picsum.photos/200/200?random=1",
        publishedAt: makeDate(2025, 11, 20, 14, 52),
        isBreaking: false
    ),
    NotificationNewsModel(
        id: 2,
        category: "nanotechnology",
        title: "Nano Robots Could Revolutionize Medicine",
        summary: "Researchers demonstrate nanobots that can deliver medicine directly to targeted cells, potentially reducing side effects and improving recovery time.",
        source: "Nature",
        sourceURL: "https://example.com/article/nano-robots",
        imageURL: "https://picsum.photos/200/200?random=2",
        publishedAt: makeDate(2025, 11, 19, 9, 30),
        isBreaking: true
    ),
    NotificationNewsModel(
        id: 3,
        category: "blockchain",
        title: "Decentralized Identity Gains Traction",
        summary: "A new decentralized identity protocol is gaining adoption across fintech apps, providing users with greater control over personal data.",
        source: "CoinDesk",
        sourceURL: "https://example.com/article/decentralized-id",
        imageURL: "https://picsum.photos/200/200?random=3",
        publishedAt: makeDate(2025, 11, 18, 16, 0),
        isBreaking: false
    ),
    NotificationNewsModel(
        id: 4,
        category: "artificial_intelligence",
        title: "AI Predicts Protein Structures in Minutes",
        summary: "The latest AI models can predict complex protein structures faster than ever, potentially accelerating drug discovery and research.",
        source: "ScienceDaily",
        sourceURL: "https://example.com/article/ai-proteins",
        imageURL: "https://picsum.photos/200/200?random=4",
        publishedAt: makeDate(2025, 11, 17, 11, 15),
        isBreaking: true
    ),
    NotificationNewsModel(
        id: 5,
        category: "fashion-tech",
        title: "Wearable Tech Blends Fashion and Function",
        summary: "New smart clothing line integrates sensors into everyday wearables, allowing tracking of health metrics in a stylish way.",
        source: "Vogue Tech",
        sourceURL: "https://example.com/article/wearable-tech",
        imageURL: "https://picsum.photos/200/200?random=5",
        publishedAt: makeDate(2025, 11, 16, 10, 0),
        isBreaking: false
    )
]
