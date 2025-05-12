//
//  CardLocalDataSourceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import CoreData

protocol CardLocalDataSourceProtocol {
    func save(cards: [YuGiOhCard]) throws
    func fetchAll() -> [YuGiOhCard]
}
