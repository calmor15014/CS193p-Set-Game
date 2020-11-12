//
//  SetCardView.swift
//  Set Game
//
//  Created by James Spece on 11/1/20.
//

import SwiftUI

struct SetCardView: View {
    var card: SetGameModel.Card
    var body: some View {
        ZStack {
            // Card Background
            RoundedRectangle(cornerRadius: cardCornerRadius).foregroundColor(.white).transition(.identity)
            switch card.status {
            case .isSelected:
                // Card Border - selected
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderSelected)
                    .transition(.opacity)
            case .isSelectedInSet:
                // Card Border - highlighted
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderSet)
                    .transition(.opacity)
            case .isSelectedInFailedSet:
                // Card Border - highlighted
                RoundedRectangle(cornerRadius: cardCornerRadius)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderFailedSet)
                    .transition(.opacity)
            default:
                // Card Border - normal
                RoundedRectangle(cornerRadius: cardCornerRadius).stroke(lineWidth: cardBorderLineWidth).foregroundColor(cardBorderNormal)
            }
            cardBody()
                .foregroundColor(shapeColor(colorValue: card.color))
                .padding(cardPadding)
        }
    }
    
    @ViewBuilder
    private func cardBody() -> some View {
        switch card.number {
        case .value3:
            VStack{
                cardShape(shapeValue: card.shape, shadingValue: card.style)
                cardShape(shapeValue: card.shape, shadingValue: card.style)
                cardShape(shapeValue: card.shape, shadingValue: card.style)
            }
        case .value2:
            VStack {
                cardShape(shapeValue: card.shape, shadingValue: card.style)
                cardShape(shapeValue: card.shape, shadingValue: card.style)
            }
        case .value1:
            cardShape(shapeValue: card.shape, shadingValue: card.style)
        }
    }

    @ViewBuilder
    private func cardShape(shapeValue: SetCardValues, shadingValue: SetCardValues) -> some View {
        switch shapeValue {
        case .value1:
            shapeShading(shape: Oval(), shadingValue: shadingValue)
        case .value2:
            shapeShading(shape: Squiggle(), shadingValue: shadingValue)
        case .value3:
            shapeShading(shape: Diamond(), shadingValue: shadingValue)
        }
    }

    @ViewBuilder
    private func shapeShading<setShape>(shape: setShape, shadingValue: SetCardValues) -> some View where setShape: Shape{
        switch shadingValue {
        case .value1:
            shape.stroke()
        case .value2:
            shape.fill()
        case .value3:
            shape.fill().opacity(stripedOpacity)
        }
    }

    private func shapeColor(colorValue: SetCardValues) -> Color {
        switch colorValue {
        case .value1:
            return .green
        case .value2:
            return .red
        case .value3:
            return .purple
        }
    }
    
    // MARK: - Drawing Constants
    private let cardCornerRadius: CGFloat = 10
    private let cardPadding: CGFloat = 5
    private let cardBorderLineWidth: CGFloat = 1
    private let cardBorderLineWidthSelected: CGFloat = 6
    private let cardBorderNormal = Color.blue
    private let cardBorderSelected = Color.yellow
    private let cardBorderSet = Color.green
    private let cardBorderFailedSet = Color.red
    private let stripedOpacity: Double = 0.3
}



struct SetCardView_Previews: PreviewProvider {
    static var previews: some View {
        let card = SetGameModel.Card(id: 1, number: .value1, shape: .value1, color: .value1, style: .value1, displayPosition: 1, isSelected: true, inSet: true)
        SetCardView(card: card).padding()
    }
}
