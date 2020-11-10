//
//  ArrayExtensions.swift
//  Set Game
//
//  Created by James Spece on 10/26/20.
//

import Foundation

extension Array where Element: Identifiable {
    /// Returns the index of the first element that matches in an array of Identifiable elements
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        return nil
    }
}

extension Array where Element: Numeric {
    /// Returns the sum of all elements in an array of numeric elements
    func sum() -> Element {
        var total: Element = 0
        for element in self {
            total += element
        }
        return total
    }
}
