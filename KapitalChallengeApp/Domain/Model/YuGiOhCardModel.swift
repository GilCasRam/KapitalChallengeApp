//
//  Amiibo.swift
//  KapitalChallengeApp
//
//  Created by Gil Alfredo Casimiro Ramírez on 09/05/25.
//

import Foundation

struct AmiiboModel: Identifiable, Codable {
    let id = UUID()
    let name: String
    let image: String
    let amiiboSeries: String

    enum CodingKeys: String, CodingKey {
        case name
        case image
        case amiiboSeries = "amiiboSeries"
    }
}

struct AmiiboResponse: Codable {
    let amiibo: [AmiiboModel]
}
