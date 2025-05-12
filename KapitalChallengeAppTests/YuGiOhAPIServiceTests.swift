//
//  YuGiOhAPIServiceTests.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 11/05/25.
//

import XCTest
@testable import KapitalChallengeApp

/// Unit tests for `YuGiOhAPIService`, using a mocked URLProtocol to simulate network responses.
final class YuGiOhAPIServiceTests: XCTestCase {
    
    /// The service under test
    var service: YuGiOhAPIService!

    /// Sets up the mocked URLSession and injects it into the service before each test
    override func setUp() {
        super.setUp()

        // Create a custom URLSession configuration using the mock protocol
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]

        // Inject the mocked session into the API service
        let session = URLSession(configuration: config)
        service = YuGiOhAPIService(session: session)
    }

    /// Tests that `fetchCards()` successfully decodes and returns the correct card from the mock JSON response
    func testFetchCards_returnsCorrectCard() async throws {
        // Sample mock JSON response
        let json = """
        {
          "data": [
            {
              "id": 123,
              "name": "Dark Magician",
              "type": "Spellcaster",
              "desc": "The ultimate wizard.",
              "atk": 2500,
              "def": 2100,
              "level": 7,
              "race": "Normal",
              "attribute": "DARK",
              "card_images": [
                { "image_url": "https://example.com/card.jpg" }
              ]
            }
          ]
        }
        """.data(using: .utf8)!

        // Assign the mock data to the protocol mock
        URLProtocolMock.mockResponseData = json

        // Call the method under test
        let cards = try await service.fetchCards()

        // Assert the result matches expected values
        XCTAssertEqual(cards.count, 1)
        XCTAssertEqual(cards.first?.name, "Dark Magician")
        XCTAssertEqual(cards.first?.atk, 2500)
    }
}

