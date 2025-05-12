//
//  Amiibo.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

struct YuGiOhCardResponse: Decodable {
    let data: [YuGiOhCard]
}

struct YuGiOhCard: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let type: String
    let desc: String
    let atk: Int?
    let def: Int?
    let level: Int?
    let race: String?
    let attribute: String?
    let cardImages: [CardImage]

    enum CodingKeys: String, CodingKey {
        case id
        case name, type, desc, atk, def, level, race, attribute
        case cardImages = "card_images"
    }
    
    static func == (lhs: YuGiOhCard, rhs: YuGiOhCard) -> Bool {
           return lhs.id == rhs.id
       }

    var imageUrl: String {
        cardImages.first?.imageURL ?? ""
    }
}

struct CardImage: Decodable {
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
    }
}
