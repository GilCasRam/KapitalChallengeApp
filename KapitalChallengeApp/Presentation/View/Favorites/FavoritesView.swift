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
                    Text("Aún no hay cartas favoritas.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                } else {
                    List {
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
                    .listStyle(.plain)
                    .refreshable {
                        favoriteCards = viewModel.localDataSource.fetchFavoriteCards()
                    }
                }
            }
            .navigationTitle("⭐️ Favoritos")
        }
        .onAppear {
            favoriteCards = viewModel.localDataSource.fetchFavoriteCards()
        }
    }
}

struct FavoriteCardRowView: View {
    let card: YuGiOhCard
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: card.imageUrl))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.headline)
                Text(card.type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}
