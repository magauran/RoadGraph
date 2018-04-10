//
//  RoadGraph+ShortestPath.swift
//  RoadGraph
//
//  Created by Алексей on 07.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension RoadGraph {
    
    func shortestPath(source: OSMNode, destination: OSMNode) -> [OSMNode] {
        
        print("Starting route between \(source) and \(destination)")
        
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        
        var queue = PriorityQueue<OSMNode>(order: { (lhs, rhs) -> Bool in
            return (distances[lhs] ?? Double.infinity) > (distances[rhs] ?? Double.infinity)
        })
        
        distances[source] = 0.0
        for (_, node) in self.nodes {
            queue.push(node)
        }
        
        while let node = queue.pop() {
            //Check if this node is reachable based on data
            guard let distance = distances[node], distance < Double.infinity else { continue }
            //For every neighbor
            for neighbor in node.adjacent {
                let distance = distance + node.location.distance(to: neighbor.location)
                //If the new distance is less than the existing distance, update the distance and previous entry
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.push(neighbor)
                }
            }
        }
        
        var prev = destination
        var shortestPath = [OSMNode]()
        while (prev != source) {
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        return shortestPath
    }
    
}
