//
//  Heuristic.swift
//  RoadGraph
//
//  Created by Алексей on 18.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

enum Heuristic {
    
    case Euclidean
    case Manhattan
    case Chebyshev
    
    func distance(from: CGPoint, to: CGPoint) -> Double {
        let Δx = Double(to.x - from.x)
        let Δy = Double(to.y - from.y)
        switch self {
        case .Euclidean:
            return sqrt(Δx ** 2 + Δy ** 2)
        case .Manhattan:
            return abs(Δx) + abs(Δy)
        case .Chebyshev:
            return max(abs(Δx), abs(Δy))
        }
    }
    
    func distance(from: OSMNode, to: OSMNode) -> Double {
        let fromPoint = from.location.cartesianCoordinate
        let toPoint = to.location.cartesianCoordinate
        return distance(from: fromPoint, to: toPoint)
    }
    
}
