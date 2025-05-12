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

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isOffline {
                    Text("📴 Modo Offline: mostrando datos locales")
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
                    ProgressView("Cargando cartas...")
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.cards) { card in
                            CardRowView(card: card)
                        }
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await viewModel.loadInitialCards()
                    }
                }
            }
            .navigationTitle("Yu-Gi-Oh! Cards")
        }.task {
            await viewModel.loadInitialCards()
        }
    }
}




struct CardRowView: View {
    let card: YuGiOhCard

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
        }
    }
}
