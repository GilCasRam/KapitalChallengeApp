//
//  extension.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 10/05/25.
//

import CoreData

extension YuGiOhCard {
    func toEntity(in context: NSManagedObjectContext) -> CardEntity {
        let entity = CardEntity(context: context)
        entity.id = Int64(id)
        entity.name = name
        entity.type = type
        entity.imageUrl = imageUrl
        entity.isFavorite = false
        return entity
    }
}

extension CardEntity {
    func toModel() -> YuGiOhCard {
        YuGiOhCard(
            id: Int(id),
            name: name ?? "",
            type: type ?? "",
            desc: "",
            atk: nil,
            def: nil,
            level: nil,
            race: nil,
            attribute: nil,
            cardImages: [CardImage(imageURL: imageUrl ?? "")]
        )
    }
}

extension CardLocalDataSource {
    /// Devuelve solo las cartas marcadas como favoritas desde Core Data
    func fetchFavoriteCards() -> [YuGiOhCard] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        
        do {
            let results = try context.fetch(request)
            return results.map { $0.toModel() }
        } catch {
            print("❌ Error al obtener cartas favoritas desde Core Data: \(error.localizedDescription)")
            return []
        }
    }
}
