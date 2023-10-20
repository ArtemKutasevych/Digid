//
//  Items.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import Foundation

struct Item: Codable {
    let text: String
    let confidence: Float
    let imageUrl: String
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case imageUrl = "image"
        case confidence
        case id = "_id"
    }
}
