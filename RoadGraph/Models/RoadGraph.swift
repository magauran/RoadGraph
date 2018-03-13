//
//  RoadGraph.swift
//  RoadGraph
//
//  Created by Алексей on 11.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation
import CSV


class RoadGraph {
    
    private(set) var edgeList = Array<Edge>()
    private(set) var nodes = Dictionary<String, OSMNode>()
    
    public let bounds: OSMBounds
    
    init(osm: OSM) {
        self.bounds = osm.bounds
        
        createEdgeList(map: osm)
        CSV.writeToFileWith(path: "edgeList.csv", edgeList: self.edgeList)
        
        self.nodes = osm.nodes
        CSV.writeAdjacencyListToFileWith(path: "adjacencyList", nodes: self.nodes)
        
//        let istream = InputStream(fileAtPath: csvFile.path)!
//        let csv = try! CSVReader(stream: istream)
//        while let row = csv.next() {
//            print("\(row)")
//        }
    }
    
    func createEdgeList(map: OSM) {
        for way in map.ways {
            for i in 0..<way.nodes.count - 1 {
                let edge = Edge(from: way.nodes[i], to: way.nodes[i + 1])
                self.edgeList.append(edge)
            }
        }
    }
    
    
}
