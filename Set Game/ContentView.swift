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
        VStack {
            Grid(viewmodel.cardsOnScreen) { card in
                SetCardView(card: card)
                    .padding(5)
                    .onTapGesture {
                        withAnimation(.easeOut(duration: 0.3)) {
                            viewmodel.choose(card: card)
                        }
                    }
            }
            Divider()
            HStack {
                Button("New Game") {
                    viewmodel.newGame()
                }.padding()
                Spacer()
                Button("Draw") {
                    viewmodel.drawThree()
                }.padding().disabled(!viewmodel.cardsRemaining)
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewmodel: SetGame())
    }
}
