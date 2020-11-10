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
        var cards = model.cards.filter { card in
            card.displayPosition != nil
        }
        cards.sort(by: {$0.displayPosition! < $1.displayPosition! })
        return cards
    }
    
    var cardsRemaining: Bool {
        get {
            return model.cardsInDeck > 0
        }
    }
    
    init() {
        model = SetGameModel()
    }
    
    // MARK: - Intents
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    // Once view is set up, draw 12 cards to start the game
    func startGame() {
        for _ in 0...3 {
            drawThree()
        }
    }
    
    func drawThree() {
        model.checkAndDrawThree()
    }
    
    func newGame() {
        model = SetGameModel()
        startGame()
    }
}
