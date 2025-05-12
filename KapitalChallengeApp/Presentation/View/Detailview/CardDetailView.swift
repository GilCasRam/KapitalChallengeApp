//
//  CardDetailView.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 10/05/25.
//

import SwiftUI

struct CardDetailView: View {
    let card: YuGiOhCard
    let isFavorite: Bool
    let toggleFavorite: () -> Bool
    
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                CachedAsyncImage(url: URL(string: card.imageUrl))
                Text(card.name)
                    .font(.custom("Papyrus", size: 25))
                    .foregroundColor(.black)
                    .bold()
                    .multilineTextAlignment(.leading)

                Text(card.type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)

                    Text(card.desc)
                        .font(.custom("Georgia", size: 20))
                        .padding()

                Button(action: {
                    let wasAdded = toggleFavorite()
                    alertMessage = wasAdded ? "⭐️ Added to favourites" : "⚠️ Already in favourites"
                    showAlert = true
                }) {
                    Label("Add to favourites", systemImage: "star")
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
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
        .alert(alertMessage, isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}
