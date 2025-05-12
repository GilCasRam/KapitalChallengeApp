import XCTest
@testable import YuGiOhApp

final class YuGiOhAPIServiceTests: XCTestCase {
    var service: YuGiOhAPIService!

    override func setUp() {
        super.setUp()

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolMock.self]
        let session = URLSession(configuration: config)

        service = YuGiOhAPIService(session: session)
    }

    func testFetchCards_returnsCorrectCard() async throws {
        // Arrange: JSON simulado
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

        URLProtocolMock.mockResponseData = json

        // Act
        let cards = try await service.fetchCards()

        // Assert
        XCTAssertEqual(cards.count, 1)
        XCTAssertEqual(cards.first?.name, "Dark Magician")
        XCTAssertEqual(cards.first?.atk, 2500)
    }
}
