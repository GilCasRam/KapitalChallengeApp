//
//  CardLocalDataSource.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import CoreData

/// Concrete implementation of `CardLocalDataSourceProtocol`
/// Handles saving and retrieving Yu-Gi-Oh cards using Core Data.
final class CardLocalDataSource: CardLocalDataSourceProtocol {
    
    /// The Core Data managed object context used for all database operations
    let context: NSManagedObjectContext
    
    /// Initializes the data source with a given Core Data context
    /// - Parameter context: The managed object context to use
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    /// Saves an array of `YuGiOhCard` objects to Core Data.
    /// If a card already exists (based on `id`), it updates the existing record.
    /// - Parameter cards: The cards to save
    /// - Throws: An error if the save operation fails
    func save(cards: [YuGiOhCard]) throws {
        for card in cards {
            // Check if the card already exists in Core Data
            let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
            
            let existingEntity = try context.fetch(fetchRequest).first
            
            // Use the existing entity or create a new one
            let entity = existingEntity ?? CardEntity(context: context)
            entity.id = Int64(card.id)
            entity.name = card.name
            entity.type = card.type
            entity.imageUrl = card.imageUrl
            entity.desc = card.desc
        }
        
        // Save the context to persist the changes
        try context.save()
    }
    
    /// Fetches all Yu-Gi-Oh cards stored in Core Data.
    /// - Returns: An array of `YuGiOhCard` models
    func fetchAll() -> [YuGiOhCard] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        do {
            // Map Core Data entities to domain models
            return try context.fetch(request).map { $0.toModel() }
        } catch {
            print("❌ Failed to fetch from Core Data: \(error.localizedDescription)")
            return []
        }
    }

    /// Toggles the favorite status of a card with the given ID
    /// - Parameter cardId: The ID of the card to toggle
    func toggleFavorite(for cardId: Int) {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", cardId)
        
        if let result = try? context.fetch(request).first {
            result.isFavorite.toggle()
            try? context.save()
        }
    }

    /// Fetches only the cards marked as favorites
    /// - Returns: An array of favorite `YuGiOhCard` models
    func fetchFavorites() -> [YuGiOhCard] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == YES")
        
        do {
            return try context.fetch(request).map { $0.toModel() }
        } catch {
            return []
        }
    }
}

