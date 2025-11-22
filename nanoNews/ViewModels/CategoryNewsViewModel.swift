//
//  CategoryNewsViewModel.swift
//  techNotify
//
//  Created by Alex on 21/11/2025.
//

import Foundation

@MainActor
class CategoryNewsViewModel: ObservableObject {

    // MARK: - Published Properties ---------------------------------------------

    @Published var notifications: [NotificationNewsModel] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // The category currently being displayed
    var category: String


    // MARK: - Init --------------------------------------------------------------

    init(category: String, useDummyData: Bool = false) {
        self.category = category
//        fetchNews()
        self.category = category
                if useDummyData {
                    loadDummyData()
                } else {
                    fetchNews()
                }
    }


    // MARK: - Fetch News --------------------------------------------------------

    func fetchNews(offset: Int = 0, limit: Int = 20) {

        isLoading = true
        errorMessage = nil

        NetworkManager.shared.fetchCategoryNotifications(
            category: category,
            offset: offset,
            limit: limit
        ) { [weak self] result in

            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                switch result {
                case .success(let news):
                    self.notifications = news

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Dummy Data ----------------------------------------
    
    func loadDummyData() {
            self.isLoading = false
            self.notifications = dummyNews.filter { $0.category == category }
        }


    // MARK: - Refresh (Pull-to-Refresh) ----------------------------------------

    func refresh() {
        fetchNews(offset: 0)
    }
}
