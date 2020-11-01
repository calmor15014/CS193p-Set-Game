//
//  SetCardView.swift
//  Set Game
//
//  Created by James Spece on 11/1/20.
//

import SwiftUI

struct SetCardView: View {
    var card: SetCard
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15).foregroundColor(.white)
            RoundedRectangle(cornerRadius: 15).stroke(lineWidth: cardBorderLineWidth).foregroundColor(cardBorder)
            card(content: card)
                .foregroundColor(shapeColor(content: card.shapeColor))
        }.padding(cardPadding)
    }
    
    @ViewBuilder
    private func card(content: SetCard) -> some View {
        switch content.numberOfShapes {
        case 3:
            VStack{
                cardShape(content: content)
                cardShape(content: content)
                cardShape(content: content)
            }.padding()
        case 2:
            VStack {
                cardShape(content: content)
                cardShape(content: content)
            }.padding()
        default:
            cardShape(content: content).padding()
        }
    }

    @ViewBuilder
    private func cardShape(content: SetCard) -> some View {
        let shading = content.shapeShading
        switch content.shapeStyle {
        case .Oval:
            shapeShading(shape: Oval(), shading: shading)
        case .Squiggle:
            shapeShading(shape: Squiggle(), shading: shading)
        case .Diamond:
            shapeShading(shape: Diamond(), shading: shading)
        }
    }

    @ViewBuilder
    private func shapeShading<setShape>(shape: setShape, shading: SetCard.ShapeShadings) -> some View where setShape: Shape{
        switch shading {
        case .Open:
            shape.stroke()
        case .Solid:
            shape.fill()
        case .Striped:
            shape.fill().opacity(0.3)
        }
    }

    private func shapeColor(content: SetCard.ShapeColors) -> Color {
        switch content {
        case .Green:
            return .green
        case .Red:
            return .red
        case .Purple:
            return .purple
        }
    }
    
    // MARK: - Drawing Constants
    private let cardPadding: CGFloat = 5
    private let cardBorderLineWidth: CGFloat = 2
    private let cardBorder = Color.blue
}



struct SetCardView_Previews: PreviewProvider {
    static var previews: some View {
        SetCardView(card: SetCard(numberOfShapes: 3, shapeStyle: .Oval, shapeShading: .Striped, shapeColor: .Purple))
    }
}
