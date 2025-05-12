//
//  FavoriteCardRowView.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 10/05/25.
//

import SwiftUI

struct FavoriteCardRowView: View {
    let card: YuGiOhCard
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            CachedAsyncImage(url: URL(string: card.imageUrl))
                .frame(width: 60, height: 60)
            
            VStack(alignment: .leading) {
                Text(card.name)
                    .font(.custom("Papyrus", size: 15))
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
        .padding()
        .background(Color.red.opacity(0.1))
    }
}
