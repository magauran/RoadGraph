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
    
    @IBOutlet weak var placesOutlineView: NSOutlineView!
    
    var graph: RoadGraph!
    var places = [Coordinate]()
    var isGraphCreated = false
    var controller: GraphController!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePlace(notification:)), name: NSNotification.Name(rawValue: "DeletePlace"), object: nil)
        
        createGraph()
    }

    // MARK: - IBActions
    
    @IBAction func addPlaceButton(_ sender: NSButton) {
        let placeLatitude = placeLatitudeTextField.doubleValue
        let placeLongitude = placeLongitudeTextField.doubleValue
        let placeCoordinates = Coordinate(latitude: placeLatitude, longitude: placeLongitude)
        
        if isGraphCreated {
            if graph.bounds.contains(point: placeCoordinates) {
                places.append(placeCoordinates)
                self.placesOutlineView.reloadData()
                controller.addPlace(placeCoordinates)
                self.refreshWebViewContents()
            }
        }
    }
    
    @IBAction func getRoutesButton(_ sender: NSButton) {
        let userLatitude = userLatitudeTextField.doubleValue
        let userLongitude = userLongitudeTextField.doubleValue
        let userCoordinates = Coordinate(latitude: userLatitude, longitude: userLongitude)
        
        if isGraphCreated, graph.bounds.contains(point: userCoordinates), !places.isEmpty {
            print("Проложить маршрут от \(userCoordinates) до \(places)")
            if let userNode = graph.nodes(near: userCoordinates, radius: 500).first {
                for place in places {
                    if let placeNode = graph.nodes(near: place, radius: 500).first {
                        let path = graph.shortestPath(source: userNode, destination: placeNode)
                        self.controller.drawPath(path)
                        self.refreshWebViewContents()
                        // надо находить кратчайший путь
                    }
                }
            }
        }
        
    }
    
    
    // MARK: - Private methods
    
    @objc private func deletePlace(notification: Notification) {
        if let tag = notification.userInfo!["tag"] as? Int {
            if tag < places.count {

                places.remove(at: tag)
                placesOutlineView.reloadData()

                DispatchQueue.global().async {
                    self.controller.visualize()
                    for i in self.places {
                        self.controller.addPlace(i)
                    }
                    let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
                    let htmlString = try! String.init(contentsOf: svgUrl)

                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(htmlString, baseURL: nil)
                    }
                }

            }
        }
    }
    private func createGraph() {
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
    
    private func refreshWebViewContents() {
        let svgUrl = Bundle.main.bundleURL.appendingPathComponent("Contents/Resources/graph.html")
        let htmlString = try! String.init(contentsOf: svgUrl)
        self.webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
}


extension ViewController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        return places.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return [index, places[index]]
    }
    
}


extension ViewController: NSOutlineViewDelegate {
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: PlaceTableCellView?
        
        if let array = item as? Array<Any> {
            if let coordinates = array[1] as? Coordinate {
                view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PlaceCell"), owner: self) as? PlaceTableCellView
                view?.setupCellData(tag: array[0] as! Int, coordinates: coordinates)
                
            }
        }
        
        return view
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return false
    }
    
}
