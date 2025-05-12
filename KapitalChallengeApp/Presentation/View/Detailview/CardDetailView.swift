import SwiftUI

struct CardDetailView: View {
    let card: YuGiOhCard
    let isFavorite: Bool
    let toggleFavorite: () -> Void
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let data = card.imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .cornerRadius(12)
                } else {
                    AsyncImage(url: URL(string: card.imageUrl)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                }

                Text(card.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)

                Text(card.type)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let desc = card.desc {
                    Text(desc)
                        .font(.body)
                        .padding()
                }

                Button(action: {
                    let wasAdded = toggleFavorite()
                    alertMessage = wasAdded ? "⭐️ Se agregó a favoritos" : "⚠️ Ya está en favoritos"
                    showAlert = true
                }) {
                    Label("Agregar a favoritos", systemImage: "star")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
