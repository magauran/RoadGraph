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
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let csvFile = documentDirectory.appendingPathComponent(path)
        
        if !fileManager.fileExists(atPath: csvFile.path) {
            fileManager.createFile(atPath: csvFile.path, contents: nil, attributes: nil)
        }
        
        let stream = OutputStream(toFileAtPath: csvFile.path, append: false)!
        let csv = try! CSVWriter(stream: stream)
            
        for edge in edgeList {
            try! csv.write(row: [edge.from.id, edge.to.id])
        }
        
    }
    
    class func writeAdjacencyListToFileWith(path: String, nodes: Dictionary<String, OSMNode>) {
        
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let csvFile = documentDirectory.appendingPathComponent(path)
        
        if !fileManager.fileExists(atPath: csvFile.path) {
            fileManager.createFile(atPath: csvFile.path, contents: nil, attributes: nil)
        }
        
        let stream = OutputStream(toFileAtPath: csvFile.path, append: false)!
        let csv = try! CSVWriter(stream: stream)
        
        for node in nodes {
            var array = [node.key]
            if node.value.adjacent.count > 0 {
                array.append(contentsOf: node.value.adjacent.map {$0.id})
                try! csv.write(row: array)
            }
        }
        
    }
    
}
