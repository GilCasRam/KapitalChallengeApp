//
//  AmiiboViewModel.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

@MainActor
final class CardsViewModel: ObservableObject {
    @Published var cards: [YuGiOhCard] = []
    @Published var isLoading = false
    @Published var hasMore = true

    private let apiService: YuGiOhAPIServiceProtocol
    private var currentOffset = 0
    private let limit = 20

    init(apiService: YuGiOhAPIServiceProtocol = YuGiOhAPIService()) {
        self.apiService = apiService
    }

    func loadInitialCards() async {
        cards = []
        currentOffset = 0
        hasMore = true
        await loadMoreCards()
    }

    func loadMoreCards() async {
        guard !isLoading, hasMore else { return }
        isLoading = true

        do {
            let newCards = try await apiService.fetchCards(offset: currentOffset, limit: limit)
            cards += newCards
            currentOffset += limit
            hasMore = newCards.count == limit
        } catch {
            print("❌ Error: \(error.localizedDescription)")
        }

        isLoading = false
    }
}

