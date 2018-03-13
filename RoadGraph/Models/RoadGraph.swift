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
    public let bounds: OSMBounds
    
    init(osm: OSM) {
        self.bounds = osm.bounds
        createEdgeList(map: osm)
        
        /*
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let csvFile = documentDirectory.appendingPathComponent("edgeList.csv")
        
        if !fileManager.fileExists(atPath: csvFile.path) {
            
            fileManager.createFile(atPath: csvFile.path, contents: nil, attributes: nil)
            
            let stream = OutputStream(toFileAtPath: csvFile.path, append: false)!
            let csv = try! CSVWriter(stream: stream)
            
            for edge in edgeList {
                try! csv.write(row: [edge.from.id, edge.to.id])
            }
        }
 */
        
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
