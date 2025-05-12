//
//  CardRowView.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import SwiftUI

struct CardRowView: View {
    let card: YuGiOhCard
    var isFavorite: Bool
    var toggleFavorite: () -> Bool

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 8) {
            CachedAsyncImage(url: URL(string: card.imageUrl))
                .frame(width: 110, height: 140)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.yellow.opacity(0.8), lineWidth: 1.5)
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(card.name)
                    .font(.custom("Papyrus", size: 13))
                    .foregroundColor(Color(red: 0.9, green: 0.8, blue: 0.4))
                    .lineLimit(1)

                Text(card.type)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 160, height: 240)
        .background(Image("Back-DOR-VG").resizable().cornerRadius(12))
        .shadow(color: .gray.opacity(0.4), radius: 6, x: 3, y: 4)
        .overlay(alignment: .topTrailing) {
            Button {
                let wasAdded = toggleFavorite()
                alertMessage = wasAdded ? "⭐️ Added to favourites" : "⚠️ Already in favourites"
                showAlert = true
            } label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(isFavorite ? .yellow : .gray)
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .alert(alertMessage, isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}
