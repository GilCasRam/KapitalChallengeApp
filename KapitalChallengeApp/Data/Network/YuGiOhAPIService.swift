//
//  AmiiboAPIServiceProtocol.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

/// Concrete implementation of the `YuGiOhAPIServiceProtocol`
/// Responsible for fetching Yu-Gi-Oh cards from the public API.
final class YuGiOhAPIService: YuGiOhAPIServiceProtocol {
    
    /// The URLSession used to perform network requests
    private let session: URLSession

    /// Initializes the service with a custom or shared URLSession
    /// - Parameter session: The URLSession to use. Defaults to `.shared`.
    init(session: URLSession = .shared) {
        self.session = session
    }

    /// Fetches a list of Yu-Gi-Oh cards from the remote API with pagination
    /// - Parameters:
    ///   - offset: The number of cards to skip (for pagination). Default is 0.
    ///   - limit: The number of cards to fetch. Default is 20.
    /// - Returns: An array of `YuGiOhCard` objects
    /// - Throws: A `URLError` if the data cannot be parsed
    func fetchCards(offset: Int = 0, limit: Int = 20) async throws -> [YuGiOhCard] {
        // Construct the API URL with query parameters for pagination
        let url = URL(string: "https://db.ygoprodeck.com/api/v7/cardinfo.php?num=\(limit)&offset=\(offset)")!
        
        // Perform the network request
        let (data, _) = try await session.data(from: url)

        do {
            // Decode the response into the expected model
            let response = try JSONDecoder().decode(YuGiOhCardResponse.self, from: data)
            return response.data
        } catch {
            // Log the decoding error and rethrow a generic parsing error
            print("🧨 Decoding error: \(error)")
            throw URLError(.cannotParseResponse)
        }
    }
}
