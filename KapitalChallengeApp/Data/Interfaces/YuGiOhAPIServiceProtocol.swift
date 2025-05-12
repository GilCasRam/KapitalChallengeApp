//
//  YuGiOhAPIServiceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import Foundation

// Protocol that defines the contract for fetching Yu-Gi-Oh cards from a remote API
protocol YuGiOhAPIServiceProtocol {

    /// Fetches Yu-Gi-Oh cards from the remote API using pagination.
    /// - Parameters:
    ///   - offset: The number of items to skip before starting to collect the result set.
    ///   - limit: The maximum number of cards to fetch.
    /// - Returns: An array of `YuGiOhCard` objects fetched from the API.
    /// - Throws: An error if the network request or decoding fails.
    func fetchCards(offset: Int, limit: Int) async throws -> [YuGiOhCard]
}

