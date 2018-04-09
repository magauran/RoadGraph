//
//  RoadGraph.swift
//  RoadGraph
//
//  Created by Алексей on 11.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class RoadGraph {
    
    private(set) var edgeList = Array<Edge>()
    private(set) var nodes = Dictionary<String, OSMNode>()
    
    public let bounds: OSMBounds
    
    init(osm: OSM) {
        self.bounds = osm.bounds
        
        createEdgeList(map: osm)
        
        self.nodes = osm.nodes
        
    }
    
    public func createEdgeList(map: OSM) {
        for way in map.ways {
            for i in 0..<way.nodes.count - 1 {
                let edge = Edge(from: way.nodes[i], to: way.nodes[i + 1], width: self.getEdgeWidth(type: way.tags["highway"]!))
                self.edgeList.append(edge)
            }
        }
    }
    
    public func getEdgeWidth(type: String) -> Double {
      
        switch type {
        case "motorway", "motorway":
            return 0.8
        case "trunk", "trunk_link":
            return 0.7
        case "primary", "primary_link":
            return 0.6
        case "secondary", "secondary_link":
            return 0.5
        case "tertiary", "tertiary_link":
            return 0.4
        case "unclassified":
            return 0.3
            
        default:
            return 0.2
        }
    }
    
    public func nodes(near startLocation: Coordinate, radius searchRadius: Int = 50) -> [OSMNode] {
        var found = Array<OSMNode>()
        
        for (_, node) in nodes {
            let distance = startLocation.distance(to: node.location)
            if distance < Double(searchRadius) {
                found.append(node)
            }
        }
        
        return found.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.location.distance(to: startLocation) < rhs.location.distance(to: startLocation)
        })
    }
}
