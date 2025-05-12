//
//  YuGiOhAPIServiceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import Foundation

protocol YuGiOhAPIServiceProtocol {
    func fetchCards(offset: Int, limit: Int) async throws -> [YuGiOhCard]
}
