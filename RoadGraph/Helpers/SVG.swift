//
//  SVG.swift
//  RoadGraph
//
//  Created by Алексей on 12.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class SVG {
    
    private var imageRect: CGRect
    private var sourceRect: CGRect
    private var svgString: String
    
    init(rect: CGRect) {
        self.sourceRect = rect
        self.imageRect = CGRect(x: 0.0, y: 0.0, width: 500, height: 500 * rect.height / rect.width)
        self.svgString = ""
    }
    
    public func saveSVGToFile() {
        let svg = "<svg height=\"\(self.imageRect.height)\" width=\"\(self.imageRect.width)\">" + self.svgString + "</svg>\n"
        
        let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.svg")
        
        do {
            try svg.write(to: svgUrl, atomically: true, encoding: .utf8)
        } catch {
            print("Failed writing to URL: \(svgUrl), Error: " + error.localizedDescription)
        }
        
    }
    
    public func saveSVGToHTMLFile() {
        let svg = "<!DOCTYPE html>\n<html>\n<body>" + "<svg height=\"\(self.imageRect.height)\" width=\"\(self.imageRect.width)\">\n" + self.svgString + "</svg>\n</body>\n</html>"
        
        let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
        
        do {
            try svg.write(to: svgUrl, atomically: true, encoding: .utf8)
        } catch {
            print("Failed writing to URL: \(svgUrl), Error: " + error.localizedDescription)
        }
    }
    
    public func drawLine(from p1: CGPoint, to p2: CGPoint, width: Double = 0.5, color: String = "#000050") {
        let point1 = convertCoordinate(initialPoint: p1, initialRect: sourceRect, resultRect: imageRect)
        let point2 = convertCoordinate(initialPoint: p2, initialRect: sourceRect, resultRect: imageRect)
        self.svgString += "<line x1=\"\(point1.x)\" y1=\"\(point1.y)\" x2=\"\(point2.x)\" y2=\"\(point2.y)\" style=\"stroke:\(color); stroke-width:\(width)\" />\n"
    }
    
    public func drawCircle(center: CGPoint, radius: CGFloat = 2, color: String = "red") {
        let centerPoint = convertCoordinate(initialPoint: center, initialRect: sourceRect, resultRect: imageRect)
        self.svgString += "<circle cx=\"\(centerPoint.x)\" cy=\"\(centerPoint.y)\" r=\"\(radius)\" fill=\"\(color)\"/>\n"
    }
    
    public func drawCircleWithNumber(center: CGPoint, radius: CGFloat, color: String = "green", number: Int, numberColor: String = "white") {
        let centerPoint = convertCoordinate(initialPoint: center, initialRect: sourceRect, resultRect: imageRect)
        self.svgString += "<circle cx=\"\(centerPoint.x)\" cy=\"\(centerPoint.y)\" r=\"\(radius)\" fill=\"\(color)\"/>\n"
        self.svgString += "<text x=\"\(centerPoint.x - (number >= 10 ? 3.3 : 1.7))\" y=\"\(centerPoint.y + 2.2)\" fill=\"\(numberColor)\" font-size=\"6\"\">\(number)</text>\n"
    }
    
    func convertCoordinate(initialPoint: CGPoint, initialRect: CGRect, resultRect: CGRect) -> CGPoint {
        let x = (initialPoint.x / initialRect.width) * resultRect.width
        let y = (initialPoint.y / initialRect.height) * resultRect.height
        return CGPoint(x: x, y: y)
    }
    
}
