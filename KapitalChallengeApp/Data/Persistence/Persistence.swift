//
//  Persistence.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Preview (opcional para SwiftUI previews)
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Aquí puedes agregar datos de ejemplo si quieres
        let example = CardEntity(context: viewContext)
        example.id = 123
        example.name = "Dark Magician"
        example.type = "Spellcaster"
        example.imageUrl = "https://images.ygoprodeck.com/cards/46986414.jpg"
        example.isFavorite = true

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Error al guardar en preview: \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "KapitalChallengeApp") // Asegúrate que este nombre coincida con tu .xcdatamodeld

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}

