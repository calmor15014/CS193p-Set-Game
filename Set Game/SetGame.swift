//
//  SetGame.swift
//  Set Game
//
//  Created by James Spece on 10/29/20.
//

import SwiftUI

class SetGame: ObservableObject {
    private var model: SetGameModel<SetCard>
    
    var numberOfCards: Int {
        get {
            return model.cards.count
        }
    }
    
    var cards: Array<SetGameModel<SetCard>.Card> {
        model.cards
    }
    
    var onScreenCards: Array<SetGameModel<SetCard>.Card> {
        model.cards.filter {
            $0.isDisplayed
        }
    }
    
    init() {
        let numberOfShapes = 3
        var cards = Array<SetCard>()
        for count in 1...numberOfShapes {
            for style in SetCard.ShapeStyles.allCases {
                for shade in SetCard.ShapeShadings.allCases {
                    for color in SetCard.ShapeColors.allCases {
                        cards.append(SetCard(numberOfShapes: count, shapeStyle: style, shapeShading: shade, shapeColor: color))
                    }
                }
            }
        }
        model = SetGameModel<SetCard>(numberOfCards: cards.count, cardCreator: { (cardNo: Int) -> SetCard in
            return cards[cardNo]
        })
    }
    
    func getCard(index: Int) -> SetCard {
        return model.cards[index].content
    }
}

struct SetCard {
    
    enum ShapeStyles: CaseIterable{
        case Squiggle
        case Oval
        case Diamond
    }
    enum ShapeShadings: CaseIterable {
        case Solid
        case Striped
        case Open
    }
    enum ShapeColors: CaseIterable {
        case Red
        case Green
        case Purple
    }
    
    var numberOfShapes: Int
    var shapeStyle: ShapeStyles
    var shapeShading: ShapeShadings
    var shapeColor: ShapeColors
}

