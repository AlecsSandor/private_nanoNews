//
//  NewsItemView.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import SwiftUI

struct NewsItemView: View {
    let news: NotificationNewsModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.2)) // adjust opacity
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )

            HStack(alignment: .top, spacing: 12) {
                // Optional image
                if let imageUrl = news.imageURL, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 80, height: 80)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }

                // Title + Summary
                VStack(alignment: .leading, spacing: 6) {
                    Text(news.title)
                        .font(.headline)
                        .foregroundColor(.white)
                        .lineLimit(2)

                    Text(news.summary)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(4)

                    Text(news.source)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.top, 4)
                }
            }
            .padding(12)
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}
