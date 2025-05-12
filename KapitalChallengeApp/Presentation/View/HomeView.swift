//
//  HomeView.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import SwiftUI
import CoreData

struct CardsListView: View {
    @StateObject var viewModel: CardsViewModel
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                TextField("Search card...", text: $viewModel.searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.vertical)
                if viewModel.isOffline {
                    Text("📴 Offline mode: displaying local data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .padding(.bottom, 5)
                }
                if viewModel.isLoading && viewModel.cards.isEmpty {
                    Spacer()
                    ProgressView("Loading cards...")
                        .frame(maxWidth: .infinity)
                    Spacer()
                } else {
                    VStack {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(viewModel.filteredCards) { card in
                                    NavigationLink{
                                        CardDetailView(
                                            card: card,
                                            isFavorite: viewModel.isFavorite(card.id),
                                            toggleFavorite: {
                                                return viewModel.toggleFavorite(for: card.id)
                                            }
                                        )
                                    } label: {
                                        CardRowView(card: card, isFavorite: viewModel.isFavorite(card.id), toggleFavorite: {
                                            viewModel.toggleFavorite(for: card.id)
                                        })
                                        .onAppear {
                                            if card == viewModel.cards.last {
                                                Task {
                                                    await viewModel.loadMoreCards()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.loadInitialCards()
                    }
                }
            }
            .navigationTitle("Yu-Gi-Oh! Cards")
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
                .frame(maxWidth: .infinity)
            )
        }.task {
            await viewModel.loadInitialCards()
        }
    }
}
