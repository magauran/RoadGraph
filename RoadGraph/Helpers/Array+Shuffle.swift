//
//  Array+Shuffle.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension Array {
    
    public mutating func shuffle() {
        for _ in 0..<self.count / 5 {
            self.swapAt(Int(arc4random()) % self.count, Int(arc4random()) % self.count)
        }
    }
    
}
