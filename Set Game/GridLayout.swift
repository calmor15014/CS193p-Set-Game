//
//  GridLayout.swift
//  Memorize
//
//  Created by CS193p Instructor.
//  Copyright © 2020 Stanford University. All rights reserved.
//

import SwiftUI

struct GridLayout {
    private(set) var size: CGSize
    private(set) var rowCount: Int = 0
    private(set) var columnCount: Int = 0
    // Add requirement for aspectRatio
    private(set) var requiredAspectRatio: Double?
    
    init(itemCount: Int, withAspectRatio desiredAspectRatio: Double = 1, in size: CGSize) {
    
        if desiredAspectRatio != 1 {
            requiredAspectRatio = desiredAspectRatio
        }
        self.size = size
        // if our size is zero width or height or the itemCount is not > 0
        // then we have no work to do (because our rowCount & columnCount will be zero)
        guard size.width != 0, size.height != 0, itemCount > 0 else { return }
        // find the bestLayout
        // i.e., one which results in cells whose aspectRatio
        // has the smallestVariance from desiredAspectRatio
        // not necessarily most optimal code to do this, but easy to follow (hopefully)
        var bestLayout: (rowCount: Int, columnCount: Int) = (1, itemCount)
        var smallestVariance: Double?
        let sizeAspectRatio = abs(Double(size.width/size.height))
        for rows in 1...itemCount {
            let columns = (itemCount / rows) + (itemCount % rows > 0 ? 1 : 0)
            if (rows - 1) * columns < itemCount {
                let itemAspectRatio = sizeAspectRatio * (Double(rows)/Double(columns))
                let variance = abs(itemAspectRatio - desiredAspectRatio)
                if smallestVariance == nil || variance < smallestVariance! {
                    smallestVariance = variance
                    bestLayout = (rowCount: rows, columnCount: columns)
                }
            }
        }
        rowCount = bestLayout.rowCount
        columnCount = bestLayout.columnCount
    }
    
    // Computed property
    var itemSize: CGSize {
        // return zero size if there are no rows and columns
        if rowCount == 0 || columnCount == 0 {
            return CGSize.zero
        } else {
            let height = size.height / CGFloat(rowCount)
            let width = size.width / CGFloat(columnCount)
            // if there is no required aspect ratio, or the current ratio is as requred, just return that size.  If not, we have work to do
            guard let aspect = requiredAspectRatio, width / height != CGFloat(aspect) else {
                return CGSize(
                    width: width,
                    height: height
                )
            }
            // figure out what the recommended current aspect is.
            let currentAspect = width / height
            
            // layout made things wider than expected, indicating height was limiting factor, so adjust width
            if currentAspect > CGFloat(aspect) {
                return CGSize(width: height * CGFloat(aspect), height: height)
            // layout made things taller than expected, indicating width was limiting factor, so adjust height
            } else {
                return CGSize(width: width, height: width / CGFloat(aspect))
            }
        }
    }
    
    func location(ofItemAt index: Int) -> CGPoint {
        if rowCount == 0 || columnCount == 0 {
            return CGPoint.zero
        } else {
            // pad the items in the event that the aspect ratio is fixed and some blank space is available
            let hbuffer = (size.width - (itemSize.width * CGFloat(columnCount))) / 2
            let vbuffer = (size.height - (itemSize.height * CGFloat(rowCount))) / 2
            // buffer to ensure the items are centered even if the aspect ratio is fixed
            return CGPoint(
                x: (CGFloat(index % columnCount) + 0.5) * itemSize.width + hbuffer,
                y: (CGFloat(index / columnCount) + 0.5) * itemSize.height + vbuffer
            )
        }
    }
}
