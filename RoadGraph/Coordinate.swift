//
//  Coordinate.swift
//  RoadGraph
//
//  Created by Алексей on 11.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

public struct Coordinate: Encodable {
    public let latitude: Double
    public let longitude: Double
    
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    private func radians(degrees: Double) -> Double {
        return degrees * Double.pi / 180.0
    }
    
    public func distance(to: Coordinate) -> Double {
        let earthRadius = 6_371_000.0 // meters
        
        let deltaLatitude = radians(degrees: to.latitude - self.latitude)
        let deltaLongitude = radians(degrees: to.longitude - self.longitude)
        
        let a: Double = pow(sin(deltaLatitude / 2), 2) + cos(radians(degrees: self.latitude)) * cos(radians(degrees: to.latitude)) * pow(sin(deltaLongitude / 2), 2)
        let c: Double = 2 * atan2(sqrt(a), sqrt(1 - a))
        
        return earthRadius * c
    }
}

extension Coordinate: CustomStringConvertible {
    public var description: String {
        return "{lat: \(latitude), lon: \(longitude)}"
    }
}
