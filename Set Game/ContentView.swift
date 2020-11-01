//
//  ContentView.swift
//  Set Game
//
//  Created by James Spece on 10/26/20.
//

import SwiftUI

struct ContentView: View {
    var viewmodel: SetGame
    var body: some View {
        Grid(viewmodel.onScreenCards) {
            SetCardView(card: $0.content)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewmodel: SetGame())
    }
}
