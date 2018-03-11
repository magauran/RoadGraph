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
    
    public var ways: Set<OSMWay> {
        if let precomputed = self._ways {
            return precomputed
        } else {
           
            guard let osm = osm else {
                print("No reference to OSM object")
                return Set<OSMWay>()
            }
            var foundWays = Set<OSMWay>()
            
            for way in osm.ways {
                if way.nodes.contains(self) {
                    foundWays.insert(way)
                }
            }
            
            self._ways = foundWays
            return foundWays
        }
    }
    private var _ways: Set<OSMWay>? = nil
    
    public var adjacent: Set<OSMNode> {
        if let precomputed = self._adjacent {
            return precomputed
        } else {
            var foundNodes = Set<OSMNode>()
            
            for way in self.ways {
                guard let index = way.nodes.index(of: self) else {
                    print("\(self) should be in \(way) but isn't!")
                    continue
                }
                if index > 0 {
                    foundNodes.insert(way.nodes[index - 1])
                }
                if index < way.nodes.count - 1 {
                    foundNodes.insert(way.nodes[index + 1])
                }
            }
            
            self._adjacent = foundNodes
            return foundNodes
        }
    }
    
    private var _adjacent: Set<OSMNode>? = nil
    
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

extension OSMNode: CustomStringConvertible {
    public var description: String {
        return "Node{id: \(self.id), location: \(self.location)}"
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
