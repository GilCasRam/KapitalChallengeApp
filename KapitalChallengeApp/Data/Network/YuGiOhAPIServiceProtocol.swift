
import Foundation

protocol YuGiOhAPIServiceProtocol {
    func fetchCards(offset: Int, limit: Int) async throws -> [YuGiOhCard]
}