//
//  Dictionary+Contains.swift
//  RoadGraph
//
//  Created by Алексей on 17.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension Dictionary {
    func contains(key: Key) -> Bool {
        let value = self.contains { (k,_) -> Bool in key == k }
        return value
    }
}
