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
            switch card.status {
            case .isSelected:
                RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.6).offset(x:4, y: 4).transition(.opacity)
                RoundedRectangle(cornerRadius: 10).foregroundColor(.white).transition(.identity)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderSelected)
                    .opacity(0.5).transition(.opacity)
            case .isSelectedInSet:
                RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.6).offset(x:4, y: 4).transition(.opacity)
                RoundedRectangle(cornerRadius: 10).foregroundColor(.yellow).transition(.identity)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderSelected)
                    .opacity(0.5).transition(.opacity)
            case .isSelectedInFailedSet:
                RoundedRectangle(cornerRadius: 10).foregroundColor(.gray).opacity(0.6).offset(x:4, y: 4).transition(.opacity)
                RoundedRectangle(cornerRadius: 10).foregroundColor(.red).transition(.identity)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: cardBorderLineWidthSelected).foregroundColor(cardBorderSelected)
                    .opacity(0.5).transition(.opacity)
            default:
                RoundedRectangle(cornerRadius: 10).foregroundColor(Color(red: 0.965, green: 0.965, blue: 1.0)).transition(.identity)
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: cardBorderLineWidth).foregroundColor(cardBorder)
                    .opacity(0.5)
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
    private let cardPadding: CGFloat = 5
    private let cardBorderLineWidth: CGFloat = 1
    private let cardBorderLineWidthSelected: CGFloat = 2
    private let cardBorder = Color.blue
    private let cardBorderSelected = Color.blue
    private let stripedOpacity: Double = 0.3
}



//struct SetCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetCardView(card: SetCard(numberOfShapes: 3, shapeStyle: .Oval, shapeShading: .Striped, shapeColor: .Purple))
//    }
//}
