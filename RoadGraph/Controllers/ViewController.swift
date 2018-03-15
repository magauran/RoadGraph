//
//  ViewController.swift
//  RoadGraph
//
//  Created by Алексей on 11.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Cocoa
import SWXMLHash
import WebKit

class ViewController: NSViewController {
    
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGraph()
    }

    func createGraph() {
        let file = NSDataAsset(name: NSDataAsset.Name.init(rawValue: "tagil"))!
        let xml = SWXMLHash.parse(file.data)
        DispatchQueue.global().async {
            if let osm = try? OSM.init(xml: xml) {
                
                let graph = RoadGraph(osm: osm)
                let controller = GraphController(graph: graph)
                
                DispatchQueue.global().async {
                    controller.saveEdgeList()
                }
                
                DispatchQueue.global().async {
                    controller.visualize()
                    let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
                    let htmlString = try! String.init(contentsOf: svgUrl)
                    
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString, baseURL: nil)
                        self.webView.allowsMagnification = true
                        self.webView.magnification = 7.0
                    }
                }
                
                controller.saveAdjacencyList()
                
            } else {
                DispatchQueue.main.async {
                    print("fail")
                }
            }
        }
    }
    
}

