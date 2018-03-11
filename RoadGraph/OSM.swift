//
//  OSM.swift
//  RoadGraphPackageDescription
//
//  Created by Алексей on 10.03.2018.
//

import Foundation
import SWXMLHash

public class OSM {
    
    public private(set) var nodes = Dictionary<String, OSMNode>()
    public private(set) var ways = Set<OSMWay>()
    
    public init(xml: XMLIndexer) throws {
        let xmlNodes = xml["osm"]["node"]
        for xmlNode in xmlNodes.all {
            let node = try OSMNode(xml: xmlNode, osm: self)
            self.nodes[node.id] = node
            print(node.location)
        }
        
        for xmlWay in xml["osm"]["way"].all {
            let way = try OSMWay(xml: xmlWay, osm: self)

            let allowedHighwayValues = ["pedestrian", "path", "footway", "steps"]
            if let highwayValue = way.tags["highway"], way.tags["building"] == nil && allowedHighwayValues.contains(highwayValue) {
                self.ways.insert(way)
            }
        }

        self.nodes = self.nodes.filter({ (id, node) -> Bool in
            return !node.ways.isEmpty
        })
    }
    
    public func nodes(near startLocation: Coordinate, radius searchRadius: Int = 50) -> [OSMNode] {
        var found = Array<OSMNode>()
        
        for (_, node) in nodes {
            let distance = startLocation.distance(to: node.location)
            if distance < Double(searchRadius) {
                found.append(node)
            }
        }
        
        return found.sorted(by: { (lhs, rhs) -> Bool in
            return lhs.location.distance(to: startLocation) < rhs.location.distance(to: startLocation)
        })
    }
}
