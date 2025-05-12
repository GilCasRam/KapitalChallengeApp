//
//  AmiiboAPIServiceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

protocol YuGiOhAPIServiceProtocol {
    func fetchCards(offset: Int, limit: Int) async throws -> [YuGiOhCard]
}

final class YuGiOhAPIService: YuGiOhAPIServiceProtocol {
    func fetchCards(offset: Int = 0, limit: Int = 20) async throws -> [YuGiOhCard] {
        let url = URL(string: "https://db.ygoprodeck.com/api/v7/cardinfo.php?num=\(limit)&offset=\(offset)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(YuGiOhCardResponse.self, from: data)
        return response.data
    }
}
