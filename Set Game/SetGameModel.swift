//
//  SetGameModel.swift
//  Set Game
//
//  Created by James Spece on 10/27/20.
//

import Foundation

struct SetGameModel {
    private(set) var cards: Array<Card>
    
    // A game of Set has 81 cards, which have four different features, each of which have three possibilities (values)
    // It is not necessary to have a card Creator as in Memorize, since those rules are a fixed part of the game
    // How the ViewModel and View eventually display those features and values is model independent
    init() {
        cards = Array<Card>()
        
        // Loop all value cases and set up cards
        var index = 0
        for number in SetCardValues.allCases {
            for shape in SetCardValues.allCases {
                for color in SetCardValues.allCases {
                    for style in SetCardValues.allCases {
                        cards.append(Card(id: index, number: number, shape: shape, color: color, style: style))
                        index += 1
                    }
                }
            }
        }
        
        // Shuffle the cards in the deck
        cards.shuffle()
        
        // Set the first 12 cards of the deck to be displayed, after the shuffle
        for index in 0..<12 {
            cards[index].isDisplayed = true
        }
    }
    
    mutating func choose(card: Card) {
        if let chosenCard = cards.firstIndex(matching: card) {
            
            cards[chosenCard].isSelected = !cards[chosenCard].isSelected
            let selectedCards = cards.filter { card in
                card.isSelected
            }
            if selectedCards.count == 3 {
                testSet()
            }
        }
    }
    
    private mutating func testSet() {
        let chosenCards = cards.indices.filter { cards[$0].isSelected }
        
        // Only check for sets if there are 3 chosen cards
        guard chosenCards.count == 3  else { return }
        
        // Get the raw values (for checkSet's math)
        var featureArray = Array<Array<Int>>()
        for index in chosenCards {
            featureArray.append(cards[index].rawFeatureArray)
        }
        
        // Test each feature in the chosen cards one at a time to determine if it is a valid set
        var test = true
        for index in 0...3 {
            test = checkSet(values: [featureArray[0][index], featureArray[1][index], featureArray[2][index]])
            if !test { break }  // Leave if we identify it is not a set
        }
        
        //
        let indices = cards.indices.filter { cards[$0].isSelected }
        for index in indices {
            if cards[index].isSelected {
                if test {
                    cards[index].isDisplayed = false
                    cards[index].inSet = true
                }
                cards[index].isSelected = false
            }
        }
        
        if test {
            drawThree()
        }
    }
    
    private mutating func deselctAll() {
        for index in cards.indices {
            cards[index].isSelected = false
        }
    }
    
    func checkSet(values: Array<Int>) -> Bool {
        // Make sure there are three values
        if values.count != 3 {
            return false
        }
        // If any two but not all three are the same, the sum will not be divisible by 3
        return values.sum() % 3 == 0
    }
    
    /// Select the next three cards to be shown
    mutating func drawThree() {
        // Show the next three cards
        // Get the index of the first card that isn't in a set and isn't on screen
        guard let nextCard = cards.indices.first(where: { cards[$0].inSet == false && cards[$0].isDisplayed == false }) else { return }
        // No need to guard against the end case because sets are only taken in 3s so no odd leftover cards
        for index in nextCard...nextCard + 2 {
            cards[index].isDisplayed = true
        }
    }
    
    struct Card: Identifiable {
        var id: Int
        
        // Feature variables, named to help clarify View functions
        var number: SetCardValues
        var shape: SetCardValues
        var color: SetCardValues
        var style: SetCardValues
        
        // Provide the raw integer value as an array to check for a set
        var rawFeatureArray: Array<Int> {
            get {
                return [number.rawValue, shape.rawValue, color.rawValue, style.rawValue]
            }
        }
        
        var isDisplayed: Bool = false
        var isSelected: Bool = false
        var inSet: Bool = false
    }
}

enum SetCardValues : Int, CaseIterable {
    // Applying values of 1, 2, and 3 will allow testing for sets to be done by simple modulo operation
    case value1 = 1
    case value2 = 2
    case value3 = 3
}
