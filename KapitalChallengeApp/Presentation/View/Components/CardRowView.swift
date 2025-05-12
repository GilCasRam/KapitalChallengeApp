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