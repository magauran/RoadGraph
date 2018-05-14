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
                if generation == 30 {
                    genetic.stopEvolution()
                    let index1 = Int(route.nodes.index(of: nodes[0])!)
                    route.nodes <<= index1
                    route.nodes.append(nodes[0])
                    
                    let index2 = Int(route.nodes.index(of: route.nodes.last!)!)
                    let distance = route.distance + lengths[index1][index2]
                    print("Distance: \(distance)")
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
        for i in 0..<nodes.count - 1 {
            for j in i + 1..<nodes.count {
                let length = self.shortestPath(source: nodes[i], destination: nodes[j], algorithm: .AStar).1
                lengths[i][j] = length
                lengths[j][i] = length
            }
        }
        return lengths
    }
    
    private func drawPath(path: Way) { // TODO: controller?
        let dispatchGroup = DispatchGroup()
        
        var ways = [[OSMNode]]()
        for i in 0..<path.nodes.count - 1 {
            dispatchGroup.enter()
            
            DispatchQueue.global().async {
                let (p, _) = self.shortestPath(source: path.nodes[i], destination: path.nodes[i + 1])
                ways.append(p)
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
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "EnumeratePath"), object: path)
                CSV.writeShortestWaysToFile(path: "shortestWaysTSP.csv", ways: ways)
            }
        }
    }
    
}
