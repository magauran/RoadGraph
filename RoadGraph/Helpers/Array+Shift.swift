//
//  Array+Shift.swift
//  RoadGraph
//
//  Created by Алексей on 18.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension Array {
    func shiftedLeft(by rawOffset: Int = 1) -> Array {
        let clampedAmount = rawOffset % count
        let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
        return Array(self[offset ..< count] + self[0 ..< offset])
    }
    
    func shiftedRight(by rawOffset: Int = 1) -> Array {
        return self.shiftedLeft(by: -rawOffset)
    }
    
    mutating func shiftLeft(by rawOffset: Int = 1) {
        self = self.shiftedLeft(by: rawOffset)
    }
    
    mutating func shiftRight(by rawOffset: Int = 1) {
        self = self.shiftedRight(by: rawOffset)
    }
}

func << <T>(array: [T], offset: Int) -> [T] { return array.shiftedLeft(by: offset) }
func >> <T>(array: [T], offset: Int) -> [T] { return array.shiftedRight(by: offset) }
func <<= <T>(array: inout [T], offset: Int) { return array.shiftLeft(by: offset) }
func >>= <T>(array: inout [T], offset: Int) { return array.shiftRight(by: offset) }
