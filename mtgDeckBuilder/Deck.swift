//
//  Deck.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 7/28/25.
//

import Foundation
import SwiftData

@Model
class Deck: Hashable {
    var name: String
    var cards: [Card]
    var cardCount: Int {
        cards.count
    }
    init(name: String, cards: [Card]) {
        self.name = name
        self.cards = cards
    }
}
