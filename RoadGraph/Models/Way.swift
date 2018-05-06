//
//  Way.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

public class Way {
    
    public var nodes: [OSMNode]
    private var dist = -1.0;
    
    init() {
        self.nodes = []
    }
    
    init(nodes: [OSMNode], distance: Double = -1.0) {
        self.nodes = nodes
        self.dist = distance
    }
    
    func distance() -> Double {
        if dist < 0 {
            // if the distance is not established, then we compute the direct distance
            var result: Double = 0.0
            var previousCity: OSMNode?
            
            nodes.forEach { (city) in
                if let previous = previousCity {
                    result += previous.distance(to: city)
                }
                previousCity = city
            }
            
            guard let first = nodes.first, let last = nodes.last else { return result }
            
            return result + first.distance(to: last)
        } else {
            return dist
        }
    }
    
    func fitness(with totalDistance: Double) -> Double {
        return 1 - (self.dist / totalDistance)
    }
    
}
