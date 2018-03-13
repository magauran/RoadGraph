//
//  OSMWay.swift
//  RoadGraphPackageDescription
//
//  Created by Алексей on 10.03.2018.
//

import Foundation
import SWXMLHash

public class OSMWay: OSMTaggable {
    
    public let id: String
    public let tags: Dictionary<String, String>
    public let nodes: Array<OSMNode>
    
    private(set) weak var osm: OSM?
    
    init(xml: XMLIndexer, osm: OSM) throws {
        self.id = try xml.value(ofAttribute: "id")
        
        var tags = [String: String]()
        for xmlTag in xml["tag"].all {
            tags[try xmlTag.value(ofAttribute: "k")] = xmlTag.value(ofAttribute: "v")
        }
        self.tags = tags
        self.osm = osm
        let xmlNodeRefs = xml["nd"].all
        
        var nodes = Array<OSMNode>()
        nodes.reserveCapacity(xmlNodeRefs.count)
        
        for nodeRefTag in xmlNodeRefs {
            let nodeID: String = try nodeRefTag.value(ofAttribute: "ref")
            if let node = osm.nodes[nodeID] {
                nodes.append(node)
            }
        }
        self.nodes = nodes
    }
    
}

extension OSMWay: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }
}

extension OSMWay: Equatable {
    public static func ==(lhs: OSMWay, rhs: OSMWay) -> Bool {
        return lhs.id == rhs.id
    }
}

