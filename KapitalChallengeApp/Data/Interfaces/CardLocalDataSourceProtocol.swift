//
//  CardLocalDataSourceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import CoreData

// Protocol that defines the local data source responsibilities for Yu-Gi-Oh cards
protocol CardLocalDataSourceProtocol {

    // Saves an array of YuGiOhCard objects to local storage
    // - Parameter cards: An array of YuGiOhCard to be saved
    // - Throws: An error if the save operation fails
    func save(cards: [YuGiOhCard]) throws

    // Fetches all YuGiOhCard objects from local storage
    // - Returns: An array of all stored YuGiOhCard
    func fetchAll() -> [YuGiOhCard]
}
