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
    
    @IBOutlet weak var placeLatitudeTextField: NSTextField!
    
    @IBOutlet weak var placeLongitudeTextField: NSTextField!

    @IBOutlet weak var userLatitudeTextField: NSTextField!
    
    @IBOutlet weak var userLongitudeTextField: NSTextField!
    
    @IBOutlet weak var webView: WKWebView!
    
    var graph: RoadGraph!
    var places = [Coordinate]()
    var isGraphCreated = false
    var controller: GraphController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGraph()
    }

    @IBAction func addPlaceButton(_ sender: NSButton) {
        let placeLatitude = placeLatitudeTextField.doubleValue
        let placeLongitude = placeLongitudeTextField.doubleValue
        let placeCoordinates = Coordinate(latitude: placeLatitude, longitude: placeLongitude)
        
        if isGraphCreated {
            if graph.bounds.contains(point: placeCoordinates) {
                places.append(placeCoordinates)
                controller.addPlace(placeCoordinates)
                webView.reload()
                let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
                let htmlString = try! String.init(contentsOf: svgUrl)
                self.webView.loadHTMLString(htmlString, baseURL: nil)
            }
        }
    }
    
    @IBAction func getRoutesButton(_ sender: NSButton) {
        let userLatitude = userLatitudeTextField.doubleValue
        let userLongitude = userLongitudeTextField.doubleValue
        let userCoordinates = Coordinate(latitude: userLatitude, longitude: userLongitude)
        
        if isGraphCreated {
            if graph.bounds.contains(point: userCoordinates) && !places.isEmpty {
                print("Проложить маршрут от \(userCoordinates) до \(places)")
            }
        }
        
    }
    
    func createGraph() {
        let file = NSDataAsset(name: NSDataAsset.Name.init(rawValue: "tagil"))!
        let xml = SWXMLHash.parse(file.data)
        DispatchQueue.global().async {
            if let osm = try? OSM.init(xml: xml) {
                
                self.graph = RoadGraph(osm: osm)
                print(self.graph.bounds)
                self.isGraphCreated = true
                self.controller = GraphController(graph: self.graph)
                
                DispatchQueue.global().async {
                    self.controller.saveEdgeList()
                }
                
                DispatchQueue.global().async {
                    self.controller.visualize()
                    let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
                    let htmlString = try! String.init(contentsOf: svgUrl)
                    
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString, baseURL: nil)
                        self.webView.allowsMagnification = true
                        self.webView.magnification = 7.0
                    }
                }
                
                self.controller.saveAdjacencyList()
                
            } else {
                DispatchQueue.main.async {
                    print("fail")
                }
            }
        }
    }
    
}

