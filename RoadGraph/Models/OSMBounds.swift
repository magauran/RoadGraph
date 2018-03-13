//
//  OSMBounds.swift
//  RoadGraph
//
//  Created by Алексей on 13.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation
import SWXMLHash

public struct OSMBounds {
    
    public let minLat: Double
    public let minLon: Double
    public let maxLat: Double
    public let maxLon: Double
    
    public init() {
        self.minLat = 0.0
        self.minLon = 0.0
        self.maxLat = 0.0
        self.maxLon = 0.0
    }
    
    public init(xml: XMLIndexer) throws {
        self.minLat = try xml.value(ofAttribute: "minlat")
        self.minLon = try xml.value(ofAttribute: "minlon")
        self.maxLat = try xml.value(ofAttribute: "maxlat")
        self.maxLon = try xml.value(ofAttribute: "maxlon")
    }
    
}
