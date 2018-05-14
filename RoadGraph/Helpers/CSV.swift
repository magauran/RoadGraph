//
//  CSV.swift
//  RoadGraph
//
//  Created by Алексей on 13.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation
import CSV

class CSV {
    
    class func writeEdgeListToFileWith(path: String, edgeList: Array<Edge>) {
        
        let csv = try! createCSVWriter(path: path)
            
        for edge in edgeList {
            try! csv.write(row: [edge.from.id, edge.to.id])
        }
        
    }
    
    class func writeAdjacencyListToFileWith(path: String, nodes: Dictionary<String, OSMNode>) {
        
        var str = ""
        for node in nodes.values {
            if !node.adjacent.isEmpty {
                str += node.id + "," + Array(node.adjacent.map {$0.id}).joined(separator: ",") + "\n"
            }
        }
        
        let csvUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/adjacencyList.csv")
        
        do {
            try str.write(to: csvUrl, atomically: true, encoding: .utf8)
        } catch {
            print("Failed writing to URL: \(csvUrl), Error: " + error.localizedDescription)
        }
        
    }
    
    class func writeShortestWaysToFile(path: String, ways: [[OSMNode]]) {
        let csv = try! createCSVWriter(path: path)
        
        for way in ways {
            let nodes = way.map{"\($0.id)"}
            try! csv.write(row: nodes)
            csv.beginNewRow()
        }
    }
 
    private class func createCSVWriter(path: String) throws -> CSVWriter  {
        let csvFile = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/\(path)")
        
        let stream = OutputStream(toFileAtPath: csvFile.path, append: false)!
        let csv = try CSVWriter(stream: stream)
        
        return csv
    }
    
}
