//
//  PlaceTableCellView.swift
//  RoadGraph
//
//  Created by Алексей on 05.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Cocoa

class PlaceTableCellView: NSTableCellView {

    @IBOutlet weak var placeTextField: NSTextField!
    var placeTag: Int!
    
    @IBAction func deletePlace(_ sender: NSButton) {
        print("delete")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeletePlace"), object: nil, userInfo:["tag": self.placeTag])
    }
    
    public func setupCellData(tag: Int, coordinates: Coordinate) {
        let latitudeFormattedString = String.init(format: "%.5f", coordinates.latitude)
        let longitudeFormattedString = String.init(format: "%.5f", coordinates.longitude)
        placeTextField.stringValue = "\(latitudeFormattedString), \(longitudeFormattedString)"
        
        self.placeTag = tag
        self.placeTextField.sizeToFit()
    }
}
