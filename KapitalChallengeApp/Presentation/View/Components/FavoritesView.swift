import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: CardsViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.favoriteIds.isEmpty {
                    Spacer()
                    Text("Aún no hay cartas favoritas.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.cards.filter { viewModel.favoriteIds.contains($0.id) }) { card in
                            CardRowView(
                                card: card,
                                toggleFavorite: {
                                    viewModel.toggleFavorite(for: card.id)
                                }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("⭐️ Favoritos")
        }
    }
}
