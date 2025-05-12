//
//  Persistence.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import CoreData

/// A Core Data stack manager that provides persistent and in-memory containers.
/// Used to initialize and manage the Core Data context for the application.
struct PersistenceController {
    
    /// Shared singleton instance used across the app
    static let shared = PersistenceController()

    /// A preview instance used for SwiftUI previews or testing with in-memory storage
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext

        // Example data for previews
        let example = CardEntity(context: viewContext)
        example.id = 123
        example.name = "Dark Magician"
        example.type = "Spellcaster"
        example.imageUrl = "https://images.ygoprodeck.com/cards/46986414.jpg"
        example.isFavorite = true
        example.desc = "This is a sample card description"

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("❌ Failed to save preview context: \(nsError), \(nsError.userInfo)")
        }

        return controller
    }()

    /// The persistent container that encapsulates the Core Data stack
    let container: NSPersistentContainer

    /// Initializes the persistence controller with optional in-memory storage
    /// - Parameter inMemory: Whether to use in-memory storage (useful for previews/tests)
    init(inMemory: Bool = false) {
        // The name must match the Core Data model file (.xcdatamodeld)
        container = NSPersistentContainer(name: "KapitalChallengeApp")

        if inMemory {
            // Redirect persistent store to /dev/null to keep data only in memory
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // Load the persistent stores and handle any errors
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("❌ Failed to load Core Data stores: \(error), \(error.userInfo)")
            }
        }

        // Automatically merge changes from parent contexts
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
