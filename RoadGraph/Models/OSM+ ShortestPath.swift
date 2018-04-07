//
//  OSM+ ShortestPath.swift
//  RoadGraph
//
//  Created by Алексей on 07.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension OSM {
    
    func shortestPath(source: OSMNode, destination: OSMNode) -> (distances: Dictionary<OSMNode, Double>, previous: Dictionary<OSMNode, OSMNode>) {
        
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
        
        //print(queue.pop() == keefe)
        
        while let node = queue.pop() {
            //            print("Starting at \(node)")
            //Check if this node is reachable based on data
            if let distance = distances[node], distance < Double.infinity {
                //For every neighbor
                for neighbor in node.adjacent {
                    let distance = distance + node.location.distance(to: neighbor.location)
                    //If the new distance is less than the existing distance, update the distance and previous entry
                    //                    print("\t\(neighbor) is \(distance) away")
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        //Update the element
                        queue.reshuffle(element: neighbor)
                    }
                }
            }
            if node == destination {
                break
            }
        }
        
        return (distances: distances, previous: previous)
    }
    
}
