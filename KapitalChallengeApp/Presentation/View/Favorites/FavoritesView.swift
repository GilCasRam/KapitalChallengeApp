//
//  FavoritesView.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var viewModel: CardsViewModel
    @State private var favoriteCards: [YuGiOhCard] = []
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favoriteCards.isEmpty {
                    Spacer()
                    Text("No favourite cards yet.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(favoriteCards) { card in
                            FavoriteCardRowView(
                                card: card,
                                onDelete: {
                                    viewModel.toggleFavoriteRemove(for: card.id)
                                    favoriteCards = viewModel.localDataSource.fetchFavoriteCards()
                                }
                            )
                        }
                    }
                    .refreshable {
                        favoriteCards = viewModel.localDataSource.fetchFavoriteCards()
                    }
                }
            }
            .navigationTitle("⭐️ Favourites")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.85, blue: 0.6),
                        Color(red: 0.8, green: 0.65, blue: 0.3),
                        Color(red: 1.0, green: 0.9, blue: 0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
        .onAppear {
            favoriteCards = viewModel.localDataSource.fetchFavoriteCards()
        }
    }
}
