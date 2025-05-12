//
//  AmiiboViewModel.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

/// ViewModel responsible for managing Yu-Gi-Oh card data,
/// handling API/network calls, local persistence, favorites, and offline mode.
@MainActor
final class CardsViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var cards: [YuGiOhCard] = []
    @Published var isLoading = false
    @Published var hasMore = true
    @Published var isOffline = false
    @Published var message = ""
    @Published var searchText: String = ""
    @Published private(set) var favoriteIds: Set<Int> = []

    // MARK: - Dependencies & State
    
    /// Service to fetch cards from the API
    private let apiService: YuGiOhAPIServiceProtocol

    /// Local Core Data data source
    let localDataSource: CardLocalDataSource

    private var currentOffset = 0
    private let limit = 20

    // MARK: - Initialization

    /// Initializes the ViewModel with dependencies
    /// - Parameters:
    ///   - apiService: Remote API service (defaults to real implementation)
    ///   - localDataSource: Local storage handler
    init(apiService: YuGiOhAPIServiceProtocol = YuGiOhAPIService(), localDataSource: CardLocalDataSource) {
        self.apiService = apiService
        self.localDataSource = localDataSource
    }
    /// Computed property to return search card and filter
    var filteredCards: [YuGiOhCard] {
        let unique = Dictionary(grouping: cards, by: \.id).compactMap { $0.value.first }
        
        if searchText.isEmpty {
            return unique
        } else {
            return unique.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    
    
    /// Computed property to return currently favorite cards, depending on online/offline mode
    var favoriteCards: [YuGiOhCard] {
        if isOffline {
            return localDataSource.fetchFavorites()
        } else {
            return cards.filter { favoriteIds.contains($0.id) }
        }
    }
    
    // MARK: - Data Loading

    /// Loads the initial set of cards, prioritizing the API and falling back to local storage on failure
    func loadInitialCards() async {
        isLoading = true
        defer { isLoading = false }

        currentOffset = 0

        do {
            let remoteCards = try await apiService.fetchCards(offset: 0, limit: limit)
            cards = remoteCards

            // Save to Core Data for offline access
            try localDataSource.save(cards: remoteCards)

            // Update connectivity and favorites info
            self.isOffline = !NetworkMonitor.shared.isConnected
            favoriteIds = Set(localDataSource.fetchFavorites().map { $0.id })

        } catch let error as URLError where error.code == .cancelled {
            print("⚠️ Refresh cancelled, offline mode not activated.")
        } catch {
            self.isOffline = NetworkMonitor.shared.isConnected
            print("❌ Network error: \(error.localizedDescription)")

            // Fallback to local data
            cards = localDataSource.fetchAll()
            favoriteIds = Set(localDataSource.fetchFavorites().map { $0.id })
        }
    }

    /// Loads more cards using pagination, updates the `cards` array and handles offline fallback
    func loadMoreCards() async {
        guard !isLoading, hasMore else { return }
        isLoading = true

        do {
            let newCards = try await apiService.fetchCards(offset: currentOffset, limit: limit)
            cards += newCards
            currentOffset += limit
            hasMore = newCards.count == limit
            isOffline = false
        } catch {
            print("❌ Error loading more cards: \(error.localizedDescription)")
            cards = localDataSource.fetchAll()
            isOffline = true
        }

        isLoading = false
    }

    // MARK: - Favorites Handling

    /// Checks whether a card is marked as favorite
    func isFavorite(_ cardId: Int) -> Bool {
        favoriteIds.contains(cardId)
    }

    /// Toggles a card as favorite (only adds if not already)
    /// - Returns: `true` if the card was added to favorites, `false` if it was already present
    func toggleFavorite(for cardId: Int) -> Bool {
        if favoriteIds.contains(cardId) {
            return false
        } else {
            localDataSource.toggleFavorite(for: cardId)
            favoriteIds.insert(cardId)
            return true
        }
    }

    /// Fully toggles favorite status: if it’s favorite, removes it; if not, adds it
    func toggleFavoriteRemove(for cardId: Int) {
        if favoriteIds.contains(cardId) {
            localDataSource.toggleFavorite(for: cardId)
            favoriteIds.remove(cardId)
        } else {
            localDataSource.toggleFavorite(for: cardId)
            favoriteIds.insert(cardId)
        }
    }
}
