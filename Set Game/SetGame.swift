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
            return model.numberOfCardsInDeck > 0
        }
    }
    
    var setOnScreen: Bool {
        get {
            return model.isSetOnScreen
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
    
    func cheat() {
        // If the last set wasn't wiped out, just leave
        if model.cards.filter({ card in card.status == .isSelectedInSet}).count > 0 { return }
        // See if there's a set, first
        guard let foundCards = model.findSetOnScreen() else { return }
        // Deselct anything that is already selected
        for card in model.cards.filter({ card in card.isSelected }) {
            model.choose(card: card)
        }
        // Then, select the cards in the set
        for card in foundCards {
            model.choose(card: card)
        }
    }
    
    func drawThree() {
        model.replaceSetOrDraw()
    }
    
    func newGame() {
        model = SetGameModel()
        startGame()
    }
}
