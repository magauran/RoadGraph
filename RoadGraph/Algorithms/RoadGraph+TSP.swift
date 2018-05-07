//
//  RoadGraph+TSP.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

public enum TSPAlgorithm {
    case NearestNeighbor
    case Genetic
}

extension RoadGraph {
    
    
    func solveTSP(nodes: [OSMNode], algorithm: TSPAlgorithm = .NearestNeighbor) {
        
        let lengths = calculateLengths(nodes: nodes)
       
        switch algorithm {
        case .NearestNeighbor:
            let route = NNAlgorithm.nearestNeighbor(nodes: nodes, lengths: lengths)
            drawPath(path: route)
            break
        case .Genetic:
            let genetic = GeneticAlgorithm(withCities: nodes, lengths: lengths)
            genetic.onNewGeneration = {
                (route, generation) in
                if generation == 300 {
                    genetic.stopEvolution()
                    self.drawPath(path: route)
                }
                DispatchQueue.main.async {
                    print("Generation: \(generation)")
                }
            }
            genetic.startEvolution()
            break
        }
        
        
    }
    
    private func calculateLengths(nodes: [OSMNode]) -> [[Double]] {
        var lengths = Array(repeating: Array(repeating: Double.infinity, count: nodes.count), count: nodes.count)
        let userDefaults = UserDefaults.standard
        if let decoded  = userDefaults.object(forKey: "lengths") as? Data {
            lengths = (NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [[Double]])
        } else {
            for i in 0..<nodes.count - 1 {
                for j in i + 1..<nodes.count {
                    let length = self.shortestPath(source: nodes[i], destination: nodes[j], algorithm: .AStar).1
                    lengths[i][j] = length
                    lengths[j][i] = length
                }
            }
            
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: lengths)
            userDefaults.set(encodedData, forKey: "lengths")
            userDefaults.synchronize()
        }
        return lengths
    }
    
    private func drawPath(path: Way) {
        let dispatchGroup = DispatchGroup()
        
        for i in 0..<path.nodes.count - 1 {
            dispatchGroup.enter()
            DispatchQueue.global().async {
                let (p, _) = self.shortestPath(source: path.nodes[i], destination: path.nodes[i + 1])
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
