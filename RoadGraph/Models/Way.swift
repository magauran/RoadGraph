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
    
    init() {
        self.nodes = []
    }
    
    init(nodes: [OSMNode]) {
        self.nodes = nodes
    }
    
    var distance: Double {
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
    }
    
    func fitness(with totalDistance: Double) -> Double {
        return 1 - (distance / totalDistance)
    }
    
}
