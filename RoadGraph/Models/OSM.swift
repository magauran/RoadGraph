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
    public private(set) var bounds = OSMBounds()
    
    public init(xml: XMLIndexer) throws {
        let xmlNodes = xml["osm"]["node"]
        for xmlNode in xmlNodes.all {
            let node = try OSMNode(xml: xmlNode, osm: self)
            self.nodes[node.id] = node
        }
        
        DispatchQueue.main.async {
            print(self.nodes.count)
        }
        
        for xmlWay in xml["osm"]["way"].all {
            let way = try OSMWay(xml: xmlWay, osm: self)
            
            let allowedHighwayValues = ["pedestrian", "path", "footway", "steps"]
            if let highwayValue = way.tags["highway"], way.tags["building"] == nil /*&& allowedHighwayValues.contains(highwayValue)*/ {
                self.ways.insert(way)
            }
        }
        
        DispatchQueue.main.async {
            print(self.ways.count)
        }
        
        let xmlBounds = xml["osm"]["bounds"]
        self.bounds = try OSMBounds(xml: xmlBounds)

        DispatchQueue.main.async {
            print("osm init complete")
        }
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
