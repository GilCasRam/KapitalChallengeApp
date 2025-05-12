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
