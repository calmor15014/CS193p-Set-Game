//
//  SetCardShapes.swift
//  Set Game
//
//  Created by James Spece on 10/28/20.
//

import SwiftUI

/// Simple diamond shape with adjustable aspect ratio
/// - Parameters:
///     - aspectRatio: the ratio of width-to-height, default 4:1
struct Diamond: Shape {
    var aspectRatio: CGFloat = 3

    func path(in rect: CGRect) -> Path {
        let maxHeight = (rect.width / aspectRatio) > rect.height ? rect.height : rect.width / aspectRatio
        
        let maxWidth = (maxHeight * aspectRatio) > rect.width ? rect.width : maxHeight * aspectRatio
        
        let bottom = CGPoint(x: rect.midX, y: rect.midY + maxHeight / 2)
        let left = CGPoint(x: rect.midX - maxWidth / 2, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.midY - maxHeight / 2)
        let right = CGPoint(x: rect.midX + maxWidth / 2, y: rect.midY)
        
        var p = Path()
        
        p.move(to: top)
        p.addLine(to: left)
        p.addLine(to: bottom)
        p.addLine(to: right)
        p.addLine(to: top)
        
        return p
    }
}

struct Oval: Shape {
    var aspectRatio: CGFloat =  3
    
    func path(in rect: CGRect) -> Path {
        let maxHeight = (rect.width / aspectRatio) > rect.height ? rect.height : rect.width / aspectRatio
        
        let centerLength = (maxHeight * aspectRatio) + maxHeight > rect.width ? rect.width - maxHeight : maxHeight * aspectRatio - maxHeight
        
        //let centerLength = maxWidth / 4
        
        // Draw from top left point, radius around center left
        let rectTopLeft = CGPoint(x: rect.midX - centerLength / 2, y: rect.midY - maxHeight / 2)
        let rectCenterLeft = CGPoint(x: rect.midX - centerLength / 2, y: rect.midY)
        // Then draw from to bottom right, radius around center right
        let rectBottomRight = CGPoint(x: rect.midX + centerLength / 2, y: rect.midY + maxHeight / 2)
        let rectCenterRight = CGPoint(x: rect.midX + centerLength / 2, y: rect.midY)
        
        var p = Path()
        
        p.move(to: rectTopLeft)
        p.addArc(center: rectCenterLeft, radius: maxHeight / 2, startAngle: Angle(degrees:0-90), endAngle: Angle(degrees:180-90), clockwise: true)
        p.addLine(to: rectBottomRight)
        p.addArc(center: rectCenterRight, radius: maxHeight / 2, startAngle: Angle(degrees:180-90), endAngle: Angle(degrees:0-90), clockwise: true)
        p.addLine(to: rectTopLeft)
        
        return p
    }
}

// CS193p Spring 2020 Homework 3 Extra Credit 4 - striped Shading
/// Draws vertical lines at a fixed spacing distance, in the full rect space
///
/// Used to add a striped fill to any custom shape.
///
/// Requires use of ViewModifier `.stroke()` for lines to appear, add the shape with `.stroke()` above it in a `ZStack` to trace outside if desired.
///````
///    ZStack {
///        StripedShadingRect().stroke().clipShape(RoundedRectangle())
///        RoundedRectangle().stroke()
///    }
///````
/// - Parameter spacing: space between lines, not ignoring line width
struct StripedShadingRect: Shape {

    var spacing: CGFloat = 2.5
    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.minY)
        
        var p = Path()
        p.move(to: start)
        while p.currentPoint!.x < rect.maxX {
            p.addLine(to: CGPoint(x: p.currentPoint!.x, y: rect.maxY))
            p.move(to: CGPoint(x: p.currentPoint!.x + spacing, y: rect.minY))
        }
        return p
    }
}

// Extra Credit 3 for the squiggle
// Code modified from SwiftUI Tutorials
// https://developer.apple.com/tutorials/swiftui/drawing-paths-and-shapes
//struct SquiggleParameters {
//    struct Segment {
//        let useWidth: (CGFloat, CGFloat, CGFloat)
//        let xFactors: (CGFloat, CGFloat, CGFloat)
//        let useHeight: (CGFloat, CGFloat, CGFloat)
//        let yFactors: (CGFloat, CFloat, CGFloat)
//    }
//
//    static let adjustment: CGFloat = 0.085
//    static let standardLine = (1.0, 1.0, 1.0)
//
//    static let points = [
//            Segment(
//                useWidth: standardLine,
//                xFactors: (0.0, 0.0, 0.0),
//                useHeight: standardLine,
//                yFactors: (0.0, 0.0, 0.0))
//            ),
//    ]
//
//}

struct Squiggle: Shape {
    // Don't have the squiggle done yet, but don't want to get hung up
    var aspectRatio: CGFloat = 3
    
    func path(in rect: CGRect) -> Path {
        let maxHeight = (rect.width / aspectRatio) > rect.height ? rect.height : rect.width / aspectRatio
        
        let maxWidth = (maxHeight * aspectRatio) > rect.width ? rect.width : maxHeight * aspectRatio
        
        let bottomLeft = CGPoint(x: rect.midX - maxWidth / 2, y: rect.midY - maxHeight / 2)
        let topLeft = CGPoint(x: rect.midX - maxWidth / 2, y: rect.midY + maxHeight / 2)
        let topRight = CGPoint(x: rect.midX + maxWidth / 2, y: rect.midY + maxHeight / 2)
        let bottomRight = CGPoint(x: rect.midX + maxWidth / 2, y: rect.midY - maxHeight / 2)
        
        var p = Path()
        
        p.move(to: bottomLeft)
        p.addLine(to: topLeft)
        p.addLine(to: topRight)
        p.addLine(to: bottomRight)
        p.addLine(to: bottomLeft)
        return p
    }
}

struct SetCardShapes_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Squiggle()
            Oval(aspectRatio: 4)
            Diamond().foregroundColor(.blue)
            ZStack{
                StripedShadingRect().stroke().clipShape(Oval(aspectRatio: 5))
                Oval(aspectRatio: 5).stroke(lineWidth: 2)
            }
    
        }.padding()
    }
}
