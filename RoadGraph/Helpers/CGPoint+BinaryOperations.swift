//
//  CGPoint+BinaryOperations.swift
//  RoadGraph
//
//  Created by Алексей on 13.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension CGPoint {
    
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
}
