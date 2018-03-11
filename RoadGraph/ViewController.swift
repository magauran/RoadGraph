//
//  ViewController.swift
//  RoadGraph
//
//  Created by Алексей on 11.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Cocoa
import SWXMLHash

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let file = NSDataAsset(name: NSDataAsset.Name.init(rawValue: "tagil"))!
        let xml = SWXMLHash.parse(file.data)
        DispatchQueue.global().async {
            if let osm = try? OSM.init(xml: xml) {
                DispatchQueue.main.async {
                    print("graph init")
                }
                
                let graph = RoadGraph(osm: osm)
                
            } else {
                DispatchQueue.main.async {
                    print("fail")
                }
            }
        }
        
        
    }

}

