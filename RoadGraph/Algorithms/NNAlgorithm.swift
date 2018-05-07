//
//  NNAlgorithm.swift
//  RoadGraph
//
//  Created by Алексей on 17.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class NNAlgorithm {
    
    class func nearestNeighbor(nodes: [OSMNode], lengths l: [[Double]]) -> Way {
        var path = [Int]()
        var lengths = l
        path.append(0)
        while path.count != nodes.count {
            let min = lengths[path.last!].min()!
            let indexOfMin = Int(lengths[path.last!].index(of: min)!)
            for h in 0..<lengths.count {
                lengths[path.last!][h] = Double.infinity
                lengths[h][path.last!] = Double.infinity
            }
            
            path.append(indexOfMin)
        }
        path.append(0)
        
        var distance = 0.0
        var pathNodes = [OSMNode]()
        pathNodes.append(nodes[0])
        for i in 1..<nodes.count {
            pathNodes.append(nodes[i])
            distance += l[i][i - 1]
        }
        pathNodes.append(nodes[0])
        // TODO: посчитать расстояние от последнего до первого
        return Way(nodes: pathNodes, distance: distance)
    }
    
}
