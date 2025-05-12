//
//  CardLocalDataSource.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import CoreData

protocol CardLocalDataSourceProtocol {
    func save(cards: [YuGiOhCard]) throws
    func fetchAll() -> [YuGiOhCard]
}

final class CardLocalDataSource: CardLocalDataSourceProtocol {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func save(cards: [YuGiOhCard]) throws {
        for card in cards {
            let fetchRequest: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", card.id)
            
            let existingEntity = try context.fetch(fetchRequest).first
            
            let entity = existingEntity ?? CardEntity(context: context)
            entity.id = Int64(card.id)
            entity.name = card.name
            entity.type = card.type
            entity.imageUrl = card.imageUrl
            // ⚠️ NO toques entity.isFavorite
        }
        
        try context.save()
    }
    
    
    func fetchAll() -> [YuGiOhCard] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        do {
            return try context.fetch(request).map { $0.toModel() }
        } catch {
            print("❌ Error al leer de Core Data: \(error.localizedDescription)")
            return []
        }
    }
    
    func toggleFavorite(for cardId: Int) {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", cardId)
        
        if let result = try? context.fetch(request).first {
            result.isFavorite.toggle()
            try? context.save()
        }
    }
    
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
