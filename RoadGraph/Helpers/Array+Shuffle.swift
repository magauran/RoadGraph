//
//  Array+Shuffle.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension Array {
    public func shuffle() -> [Element] {
        return sorted(by: { (_, _) -> Bool in
            return arc4random() < arc4random()
        })
    }
}
