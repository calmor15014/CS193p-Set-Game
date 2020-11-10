//
//  ContentView.swift
//  Set Game
//
//  Created by James Spece on 10/26/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewmodel: SetGame
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Grid(viewmodel.cardsOnScreen) { card in
                    SetCardView(card: card)
                        .padding(5)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: card.status == .isDisplayed ? 0.3 : 0.75)) {
                                viewmodel.choose(card: card)
                            }
                        }.transition(AnyTransition.offset(randomSourceLocation(in: geometry.size)))
                }.onAppear(){
                    withAnimation(.easeInOut(duration: 1.0)) {
                        viewmodel.startGame()
                    }
                }
                Divider()
                HStack {
                    Button("New Game") {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            viewmodel.newGame()
                        }
                    }.padding()
                    .transition(AnyTransition.offset(randomSourceLocation(in: geometry.size)))
                    Spacer()
                    Button("Draw") {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            viewmodel.drawThree()
                        }
                    }.padding().disabled(!viewmodel.cardsRemaining)
                    .transition(AnyTransition.offset(randomSourceLocation(in: geometry.size)))
                }
            }
        }
    }

    private func randomSourceLocation(in viewSize: CGSize) -> CGSize {
        let height = viewSize.height
        let width = viewSize.width
        let randHeight = CGFloat.random(in: 0..<height)
        let randWidth = CGFloat.random(in: 0..<width)
        
        if randWidth > (width / 2) {
            if randHeight > (height / 2) {
                return CGSize(width: width + randWidth, height: height + randHeight)
            } else {
                return CGSize(width: width + randWidth, height: 0 - height - randHeight)
            }
        } else {
            if randHeight > (height / 2) {
                return CGSize(width: 0 - width - randWidth, height: height + randHeight)
            } else {
                return CGSize(width: 0 - width - randWidth, height: 0 - height - randHeight)
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewmodel: SetGame())
    }
}
