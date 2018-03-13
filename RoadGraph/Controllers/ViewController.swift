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
    
    var layer: CALayer {
        return self.view.layer!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let file = NSDataAsset(name: NSDataAsset.Name.init(rawValue: "tagil"))!
//        let xml = SWXMLHash.parse(file.data)
//        DispatchQueue.global().async {
//            if let osm = try? OSM.init(xml: xml) {
//                DispatchQueue.main.async {
//                    print("graph init")
//                }
//
//                let graph = RoadGraph(osm: osm)
//
//            } else {
//                DispatchQueue.main.async {
//                    print("fail")
//                }
//            }
//        }
        
       let svg = SVG(rect: CGRect(x: 0.0, y: 0.0, width: 500, height: 500))
        svg.drawLine(from: CGPoint(x: 100, y: 100), to: CGPoint(x: 300, y: 300))
        svg.drawCircle(center: CGPoint(x: 200, y: 200), radius: 50)
        svg.saveSVGToFile()
    }

    
    
}

