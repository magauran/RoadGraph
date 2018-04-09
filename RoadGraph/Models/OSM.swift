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
       
        for xmlWay in xml["osm"]["way"].all {
            let way = try OSMWay(xml: xmlWay, osm: self)
            
            let allowedHighwayValues = ["motorway", "motorway_link", "trunk", "trunk_link", "primary", "primary_link", "secondary", "secondary_link", "tertiary", "tertiary_link", "unclassified", "road", "residential", "service", "living_street"]
            if let highwayValue = way.tags["highway"], allowedHighwayValues.contains(highwayValue) {
                for node in way.nodes {
                    self.nodes[node.id]?.ways.insert(way)
                }
                self.ways.insert(way)
            }
        }
        
        self.nodes = self.nodes.filter({ !$0.value.ways.isEmpty && !$0.value.adjacent.isEmpty })

        DispatchQueue.main.async {
            print(self.nodes.count)
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
    
}
