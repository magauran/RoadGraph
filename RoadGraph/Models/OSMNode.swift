//
//  OSMNode.swift
//  RoadGraphPackageDescription
//
//  Created by Алексей on 10.03.2018.
//

import Foundation
import SWXMLHash

public class OSMNode: OSMTaggable {
    
    private(set) weak var osm: OSM?
    
    public let id: String
    public let location: Coordinate
    public let tags: Dictionary<String, String>
    
    public var ways = Set<OSMWay>()
    
    public var adjacent = Set<OSMNode>()
    
    public init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        let lat: Double = try xml.value(ofAttribute: "lat")
        let lon: Double = try xml.value(ofAttribute: "lon")
        let coordinate = Coordinate(latitude: lat, longitude: lon)
        self.location = coordinate
        
        var tags = [String: String]()
        for xmlTag in xml["tag"].all {
            tags[try xmlTag.value(ofAttribute: "k")] = xmlTag.value(ofAttribute: "v")
        }
        self.tags = tags
        
        self.osm = osm
    }
    
}

extension OSMNode: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}

extension OSMNode: Equatable {
    public static func ==(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id == rhs.id
    }
}

extension OSMNode: Comparable {
    public static func <(lhs: OSMNode, rhs: OSMNode) -> Bool {
        return lhs.id < rhs.id
    }
}
