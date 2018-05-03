//
//  GraphController.swift
//  RoadGraph
//
//  Created by Алексей on 13.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class GraphController {
    
    private var graph: RoadGraph
    private var svg: SVG!
    private var sourceRect: CGRect!
    
    init(graph: RoadGraph) {
        self.graph = graph
    }
    
    public func saveAdjacencyList() {
        CSV.writeAdjacencyListToFileWith(path: "adjacencyList.csv", nodes: self.graph.nodes)
    }
    
    public func saveEdgeList() {
        CSV.writeEdgeListToFileWith(path: "edgeList.csv", edgeList: self.graph.edgeList)
    }
    
    public func visualize() {
        let point1 = Coordinate(latitude: self.graph.bounds.minLat, longitude: self.graph.bounds.minLon).cartesianCoordinate
        let point2 = Coordinate(latitude: self.graph.bounds.maxLat, longitude: self.graph.bounds.maxLon).cartesianCoordinate
        sourceRect = CGRect(x: 0.0, y: 0.0,
                                width: abs(point2.x - point1.x),
                                height: abs(point2.y - point1.y))
        svg = SVG.init(rect: sourceRect)
        for edge in graph.edgeList {
            let startPoint = edge.from.location.cartesianCoordinate
            let endPoint = edge.to.location.cartesianCoordinate
            svg.drawLine(from: CGPoint(x: startPoint.x - point1.x,
                                       y: sourceRect.height - startPoint.y + point1.y),
                         to: CGPoint(x: endPoint.x - point1.x,
                                     y: sourceRect.height - endPoint.y + point1.y),
                         width: edge.width)
        }
        svg.saveSVGToHTMLFile()
    }
    
    public func addPlace(_ place: Coordinate) {
        let point1 = Coordinate(latitude: self.graph.bounds.minLat, longitude: self.graph.bounds.minLon).cartesianCoordinate
        svg.drawCircle(center: CGPoint(x: place.cartesianCoordinate.x - point1.x,
                                       y: sourceRect.height - place.cartesianCoordinate.y + point1.y))
        svg.saveSVGToHTMLFile()
    }
    
    public func addDefaultPlace(_ place: Coordinate) {
        let point1 = Coordinate(latitude: self.graph.bounds.minLat, longitude: self.graph.bounds.minLon).cartesianCoordinate
        svg.drawCircle(center: CGPoint(x: place.cartesianCoordinate.x - point1.x,
                                       y: sourceRect.height - place.cartesianCoordinate.y + point1.y),
                       radius: 4,
                       color: "green")
        svg.saveSVGToHTMLFile()
    }
    
    public func drawPath(_ path: [OSMNode]) {
        let point1 = Coordinate(latitude: self.graph.bounds.minLat, longitude: self.graph.bounds.minLon).cartesianCoordinate
        for i in 0 ..< path.count - 1 {
            let startPoint = path[i].location.cartesianCoordinate
            let endPoint = path[i + 1].location.cartesianCoordinate
            svg.drawLine(from: CGPoint(x: startPoint.x - point1.x,
                                       y: sourceRect.height - startPoint.y + point1.y),
                         to: CGPoint(x: endPoint.x - point1.x,
                                     y: sourceRect.height - endPoint.y + point1.y),
                         width: 1,
                         color: "#FF1088")
        }
        svg.saveSVGToHTMLFile()
    }
    
}

