//
//  extension.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 10/05/25.
//

import CoreData

// MARK: - YuGiOhCard to Core Data Entity Conversion

extension YuGiOhCard {

    /// Converts a `YuGiOhCard` model into a `CardEntity` for Core Data persistence
    /// - Parameter context: The `NSManagedObjectContext` in which to insert the entity
    /// - Returns: A new `CardEntity` instance with values copied from the model
    func toEntity(in context: NSManagedObjectContext) -> CardEntity {
        let entity = CardEntity(context: context)
        entity.id = Int64(id)
        entity.name = name
        entity.type = type
        entity.imageUrl = imageUrl
        entity.desc = desc
        entity.isFavorite = false  // Default value when saving
        return entity
    }
}

// MARK: - Core Data Entity to YuGiOhCard Conversion

extension CardEntity {

    /// Converts a `CardEntity` stored in Core Data into a `YuGiOhCard` domain model
    /// - Returns: A `YuGiOhCard` instance created from the entity's stored values
    func toModel() -> YuGiOhCard {
        YuGiOhCard(
            id: Int(id),
            name: name ?? "",
            type: type ?? "",
            desc: desc ?? "",
            atk: nil, // Not stored in Core Data, set to nil
            def: nil,
            level: nil,
            race: nil,
            attribute: nil,
            cardImages: [CardImage(imageURL: imageUrl ?? "")]
        )
    }
}

// MARK: - Additional Helper: Fetch Favorite Cards

extension CardLocalDataSource {

    /// Fetches only the cards marked as favorites from Core Data
    /// - Returns: An array of `YuGiOhCard` marked as favorites
    func fetchFavoriteCards() -> [YuGiOhCard] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        
        do {
            let results = try context.fetch(request)
            return results.map { $0.toModel() }
        } catch {
            print("❌ Error getting favorite cards from Core Data: \(error.localizedDescription)")
            return []
        }
    }
}
