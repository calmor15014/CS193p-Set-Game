//
//  SetGame.swift
//  Set Game
//
//  Created by James Spece on 10/29/20.
//

import SwiftUI

class SetGame: ObservableObject {
    @Published private var model: SetGameModel

    // MARK: - Properties
    var numberOfCards: Int {
        get {
            return model.cards.count
        }
    }
    
    var cardsOnScreen: Array<SetGameModel.Card> {
        model.cards.filter { card in
            card.isDisplayed
        }
    }
    
    init() {
        model = SetGameModel()
    }
    
    // MARK: - Intents
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    func drawThree() {
        model.drawThree()
    }
    
}
