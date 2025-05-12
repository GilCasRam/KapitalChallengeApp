//
//  KapitalChallengeAppApp.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import SwiftUI

@main
struct YuGiOhApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            let context = persistenceController.container.viewContext
            let localDataSource = CardLocalDataSource(context: context)
            let viewModel = CardsViewModel(localDataSource: localDataSource)
            
            TabView {
                CardsListView(viewModel: viewModel)
                    .tabItem {
                        Label("Cards", systemImage: "rectangle.stack")
                    }
                
                FavoritesView(viewModel: viewModel)
                    .tabItem {
                        Label("Favourites", systemImage: "star.fill")
                    }
            }
            .environment(\.managedObjectContext, context)
        }
    }
}
