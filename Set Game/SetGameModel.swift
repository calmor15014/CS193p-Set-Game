//
//  SetGameModel.swift
//  Set Game
//
//  Created by James Spece on 10/27/20.
//

import Foundation

struct SetGameModel {
    private(set) var cards: Array<Card>
    private var highestDisplayPosition: Int = 0
    
    /// The next card available to from the deck
    private var indexOfNextCardInDeck: Int? {
        cards.indices.first(where: { cards[$0].status == .inDeck })
    }
    
    /// Number of cards remaining in the deck (not in play or in a matched set)
    var cardsInDeck: Int {
        get {
            return cards.indices.filter({ cards[$0].status == .inDeck }).count
        }
    }
    
    //MARK: - Initializer
    
    // A game of Set has 81 cards, which have four different features, each of which have three possibilities (values)
    // It is not necessary to have a card creator closure as in Memorize, since those rules are a fixed part of the game
    // How the ViewModel and View eventually display those features and values is model independent, shapes and colors not
    // stored on the cards themselves.
    init() {
        // Start the cards array
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
    }
    
    mutating func choose(card: Card) {
        // Make sure we can find the card
        if let chosenCard = cards.firstIndex(matching: card) {
            // Get all of the selected cards
            var selectedCards = cards.filter { card in
                card.isSelected
            }
            // Select / deselect if less than three cards are currently selected
            if selectedCards.count < 3 {
                // Select / deselct the card
                cards[chosenCard].isSelected = !cards[chosenCard].isSelected
                // if this is now the third card selected, test for set and update cards
                if selectedCards.count == 2 && cards[chosenCard].isSelected {
                    selectedCards.append(cards[chosenCard])
                    guard let validSet = testSet(cardsToTest: selectedCards) else { return }
                    for card in selectedCards {
                        if let cardIndex = cards.firstIndex(matching: card) {
                            cards[cardIndex].inSet = validSet
                        }
                    }
                }
            // If three are already selected...
            } else {
                // If there is a set, all of them are in a set, so check one
                // If in a set, remove from selected cards, add new cards, and select one that was touched unless it was in the set
                if selectedCards[0].status == .isSelectedInSet {
                    // Get three more cards, replacing the set
                    checkAndDrawThree()
                    // If card selected was not one that was in a set, select it now
                    cards[chosenCard].isSelected = cards[chosenCard].inSet == nil
                // cards weren't in a set
                } else {
                    // select only the chosen card
                    cards[chosenCard].isSelected = true
                    // deselect others (if they weren't chosen, that is...)
                    for card in selectedCards {
                        if let changingCard = cards.firstIndex(matching: card) {
                            cards[changingCard].isSelected = changingCard == chosenCard
                            cards[changingCard].inSet = nil
                        }
                    }
                }
            }
        }
    }
    
    private func testSet(cardsToTest: Array<Card>) -> Bool? {
        // Only check for sets if there are 3 chosen cards
        guard cardsToTest.count == 3  else { return nil }
        
        // Get the raw values (for checkSet's math)
        var featureArray = Array<Array<Int>>()
        for card in cardsToTest {
            featureArray.append(card.rawFeatureArray)
        }
        
        // Test each feature in the chosen cards one at a time to determine if it is a valid set
        var test = true
        for index in 0...3 {
            test = checkSet(values: [featureArray[0][index], featureArray[1][index], featureArray[2][index]])
            if !test { break }  // Leave if we identify it is not a set
        }
        
        return test
    }
    
    private func checkSet(values: Array<Int>) -> Bool {
        // Make sure there are three values
        if values.count != 3 {
            return false
        }
        // If any two but not all three are the same, the sum will not be divisible by 3
        return values.sum() % 3 == 0
    }
    
    /// Select the next three cards to be shown, replacing a currently-selected set if necessary
    mutating func checkAndDrawThree() {
        // Determine if we have a selected set of cards
        let selectedSetCards = cards.filter { card in
            card.status == .isSelectedInSet
        }
        // If so, get rid of them, then add the three
        if selectedSetCards.count == 3 {
            for card in selectedSetCards {
                if let changingCard = cards.firstIndex(matching: card) {
                    cards[changingCard].isSelected = false
                    if let nextCard = indexOfNextCardInDeck {
                        cards[nextCard].displayPosition = cards[changingCard].displayPosition
                    }
                    cards[changingCard].displayPosition = nil
                }
            }
        // Otherwise just get three new cards
        } else {
            drawThree()
        }
    }
    

    
    /// Select the next three cards to be shown
    private mutating func drawThree() {
        // Show the next three cards
        // Get the index of the first card that isn't in a set and isn't on screen
        guard let nextCard = indexOfNextCardInDeck else { return }
        // No need to guard against the end case because sets are only taken in 3s so no odd leftover cards
        for index in nextCard...nextCard + 2 {
            highestDisplayPosition += 1
            cards[index].displayPosition = highestDisplayPosition
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
        
        var displayPosition: Int?
        var isSelected: Bool = false
        var inSet: Bool?
        
        var status: CardStatus {
            if displayPosition != nil {
                if isSelected == true {
                    if inSet != nil && inSet == true {
                        return .isSelectedInSet
                    } else if inSet != nil && inSet == false {
                        return .isSelectedInFailedSet
                    } else {
                        return .isSelected
                    }
                } else {
                    return .isDisplayed
                }
            } else {
                if inSet != nil && inSet == true {
                    return .inSet
                } else {
                    return .inDeck
                }
            }
        }
        
        enum CardStatus {
            case isDisplayed
            case isSelected
            case inSet
            case isSelectedInFailedSet
            case isSelectedInSet
            case inDeck
        }
    }
}

enum SetCardValues : Int, CaseIterable {
    // Applying values of 1, 2, and 3 will allow testing for sets to be done by simple modulo operation
    case value1 = 1
    case value2 = 2
    case value3 = 3
}
