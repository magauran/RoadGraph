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
    
    class func writeToFileWith(path: String, edgeList: Array<Edge>) {
        
        let csv = try! createCSVWriter(path: path)
            
        for edge in edgeList {
            try! csv.write(row: [edge.from.id, edge.to.id])
        }
        
    }
    
    class func writeAdjacencyListToFileWith(path: String, nodes: Dictionary<String, OSMNode>) {
        
        let csv = try! createCSVWriter(path: path)
        
        for node in nodes {
            if node.value.adjacent.count > 0 {
                try! csv.write(row: [node.key] + Array(node.value.adjacent.map {$0.id}))
            }
        }
        
    }
 
    private class func createCSVWriter(path: String) throws -> CSVWriter  {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let csvFile = documentDirectory.appendingPathComponent(path)
        
        if !fileManager.fileExists(atPath: csvFile.path) {
            fileManager.createFile(atPath: csvFile.path, contents: nil, attributes: nil)
        }
        
        let stream = OutputStream(toFileAtPath: csvFile.path, append: false)!
        let csv = try CSVWriter(stream: stream)
        
        return csv
    }
    
}
