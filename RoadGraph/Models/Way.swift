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
    public var distance = -1.0;
    
    init() {
        self.nodes = []
    }
    
    init(nodes: [OSMNode], distance: Double = -1.0) {
        self.nodes = nodes
        self.distance = distance
    }
    
    func fitness(with totalDistance: Double) -> Double {
        return 1 - (self.distance / totalDistance)
    }
    
}
