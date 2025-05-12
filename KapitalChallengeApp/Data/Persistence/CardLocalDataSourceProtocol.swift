import CoreData

protocol CardLocalDataSourceProtocol {
    func save(cards: [YuGiOhCard]) throws
    func fetchAll() -> [YuGiOhCard]
}