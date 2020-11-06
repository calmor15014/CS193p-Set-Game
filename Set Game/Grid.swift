//
//  Grid.swift
//  Memorize
//
//  Created by James Spece on 10/11/20.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
// Swift in XCode 11.x required this structure to remove excessive "self" calls
//    var body: some View {
//        GeometryReader { geometry in
//            body(for: GridLayout(itemCount: items.count, in: geometry.size))
//        }
//    }
//
//    func body(for layout: GridLayout) -> some View {
//        ForEach(items) { item in
//            body(for: item, in: layout)
//        }
//    }
//
//    func body(for item: Item, in layout: GridLayout) -> some View {
//        let index = items.firstIndex(matching: item)!
//        return viewForItem(item)
//            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
//            .position(layout.location(ofItemAt: index))
//    }
    
    // Swift in XCode 12.x will allow this to work without self
    // Not sure it's as readable as the above.  Perhaps a hybrid without func body(for layout: Gridlayout)
    // would be better to simplify functions but still call GridLayout separately
    var body: some View {
        GeometryReader { geometry in
            let layout = GridLayout(itemCount: items.count, withAspectRatio: 0.65, in: geometry.size)
            ForEach(items) { item in
                let index = items.firstIndex(matching: item)!
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index))
            }
        }
    }
}
