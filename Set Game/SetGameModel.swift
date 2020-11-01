//
//  SetGameModel.swift
//  Set Game
//
//  Created by James Spece on 10/27/20.
//

import Foundation

struct SetGameModel<CardContent> {
    private(set) var cards: Array<Card>
    
    init(numberOfCards: Int, cardCreator: (Int) -> CardContent) {
        cards = Array<Card>()
        for index in 0..<numberOfCards {
            cards.append(Card(id: index, content: cardCreator(index)))
        }
        cards.shuffle()
        for index in 0..<15 {
            cards[index].isDisplayed = true
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        var content: CardContent
        var isDisplayed: Bool = false
    }
}
