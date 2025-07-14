//
//  Card.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 7/14/25.
//

import Foundation

struct Card: Decodable {
    let name: String
    let manaCost: String?
    let typeLine: String?
    let oracleText: String?
    let imageURIs: ImageURIs?
    let setName: String
    let rarity: String
    let collectorNumber: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case manaCost = "mana_cost"
        case typeLine = "type_line"
        case oracleText = "oracle_text"
        case imageURIs = "image_uris"
        case setName = "set_name"
        case rarity
        case collectorNumber = "collector_number"
    }
    
    struct ImageURIs: Decodable {
        let small: String?
        let normal: String?
        let large: String?
        let png: String?
        let artCrop: String?
        let borderCrop: String?
        
        enum CodingKeys: String, CodingKey {
            case small
            case normal
            case large
            case png
            case artCrop = "art_crop"
            case borderCrop = "border_crop"
        }
    }
}
