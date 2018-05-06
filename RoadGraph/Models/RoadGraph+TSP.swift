//
//  RoadGraph+TSP.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

extension RoadGraph {
    
    func solveTSP(nodes: [OSMNode]) {
        
        var lengths = Array(repeating: Array(repeating: Double.infinity, count: nodes.count), count: nodes.count)
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: "lengths") as? Data {
            lengths = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[Double]]
        } else {
            for i in 0..<nodes.count - 1 {
                for j in i + 1..<nodes.count {
                    let length = self.shortestPath(source: nodes[i], destination: nodes[j] ).1
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
        while path.count != nodes.count {
            let min = lengths[path.last!].min()!
            let indexOfMin = Int(lengths[path.last!].index(of: min)!)
            for h in 0..<lengths.count {
                lengths[path.last!][h] = Double.infinity
                lengths[h][path.last!] = Double.infinity
            }
            
            path.append(indexOfMin)
        }
        path.append(0)
        
        var pathNodes = [OSMNode]()
        for i in path {
            pathNodes.append(nodes[i])
        }
        
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<pathNodes.count - 1 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                let (p, _) = self.shortestPath(source: pathNodes[i], destination: pathNodes[i + 1])
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DrawPath"), object: p)
                print("путь \(i) построен")
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "RefreshWebView"), object: nil)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global()) {
            print("TSP solved")
        }
        
    }
    
    
}
