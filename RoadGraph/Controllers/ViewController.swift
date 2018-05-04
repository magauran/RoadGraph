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
    var currentPlace: Coordinate!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(deletePlace(notification:)), name: NSNotification.Name(rawValue: "DeletePlace"), object: nil)
        
        createGraph()
    }

    // MARK: - IBActions
    
    @IBAction func addPlace(_ sender: NSButton) {
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
    
    @IBAction func addCurrentPlace(_ sender: Any) {
        let userLatitude = userLatitudeTextField.doubleValue
        let userLongitude = userLongitudeTextField.doubleValue
        let userCoordinates = Coordinate(latitude: userLatitude, longitude: userLongitude)
        
        if isGraphCreated {
            if graph.bounds.contains(point: userCoordinates) {
                controller.addUserPlace(userCoordinates)
                currentPlace = userCoordinates
                self.refreshWebViewContents()
            }
        }
    }
    
    @IBAction func getRoutes(_ sender: NSButton) {
        let userLatitude = userLatitudeTextField.doubleValue
        let userLongitude = userLongitudeTextField.doubleValue
        let userCoordinates = Coordinate(latitude: userLatitude, longitude: userLongitude)
        
        if isGraphCreated, graph.bounds.contains(point: userCoordinates), !places.isEmpty {
            print("Проложить маршрут от \(userCoordinates) до \(places)")
            if let userNode = graph.nodes(near: userCoordinates, radius: 500).first {
                for place in places {
                    if let placeNode = graph.nodes(near: place, radius: 500).first {
                        let path = graph.shortestPath(source: userNode, destination: placeNode)
                        let pathStr = path.0.flatMap{"\($0.id)"}.joined(separator: ",")
                        print(pathStr) // save to csv
                        self.controller.drawPath(path.0)
                        self.refreshWebViewContents()
                    }
                }
            }
        }
        
    }
    
    @IBAction func solveTSP(_ sender: Any) {
        
        guard let start = currentPlace else {return}
        guard let startNode = graph.nodes(near: start, radius: 300).first else {return}
    
        let nodes = [startNode]
        let nodes2 = places.map{graph.nodes(near: $0, radius: 300).first!}
        let allNodes = nodes + nodes2
        
        var lengths = Array(repeating: Array(repeating: 10000000.0, count: places.count + 1), count: places.count + 1)
        let userDefaults = UserDefaults.standard
        if 1==2/*let decoded  = userDefaults.object(forKey: "lengths") as? Data*/ {
            //lengths = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[Double]]
        } else {
            for i in 0..<allNodes.count - 1 {
                for j in i + 1..<allNodes.count {
                    let length = graph.shortestPath(source: allNodes[i], destination: allNodes[j] ).1
                    lengths[i][j] = length
                    lengths[j][i] = length
                }
            }
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: lengths)
            userDefaults.set(encodedData, forKey: "lengths")
            userDefaults.synchronize()
        }
        
        var path = [Int]()
        path.append(0)
        while path.count != places.count + 1 {
            let min = lengths[path.last!].min()!
            let indexOfMin = Int(lengths[path.last!].index(of: min)!)
            for h in 0..<lengths.count {
                lengths[path.last!][h] = 100000000.0
                lengths[h][path.last!] = 100000000.0
            }
            
            path.append(indexOfMin)
        }
        path.append(0)
        
        var pathNodes = [OSMNode]()
        for i in path {
            pathNodes.append(allNodes[i])
        }
        
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<pathNodes.count - 1 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                let (p, _) = self.graph.shortestPath(source: pathNodes[i], destination: pathNodes[i + 1])
                self.controller.drawPath(p)
                print("путь \(i) построен")
                DispatchQueue.main.async {
                    self.refreshWebViewContents()
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            DispatchQueue.main.async {
                print("TSP solved")
                self.refreshWebViewContents()
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
                    
                    DispatchQueue.main.async {
                        self.addDefaultPlaces()
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
    
    private func addDefaultPlaces() {
        
        if isGraphCreated {
            self.places = Constants.defaultPlaces
            self.placesOutlineView.reloadData()
            for place in Constants.defaultPlaces {
                if graph.bounds.contains(point: place) {
                    controller.addDefaultPlace(place)
                    self.refreshWebViewContents()
                }
            }
            
        }
        
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
