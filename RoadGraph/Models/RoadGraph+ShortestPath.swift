//
//  RoadGraph+ShortestPath.swift
//  RoadGraph
//
//  Created by Алексей on 07.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

public enum Algorithm {
    case Dijkstra
    case AStar
    case Levit
}

extension RoadGraph {
    
    func shortestPath(source: OSMNode, destination: OSMNode, algorithm: Algorithm = .AStar) -> [OSMNode] {
        
        switch algorithm {
        case .Dijkstra:
            return dijkstra(source: source, destination: destination)
        case .AStar:
            return aStar(source: source, destination: destination)
        case .Levit:
            return levit(source: source, destination: destination)
        }
        
    }
    
    private func dijkstra(source: OSMNode, destination: OSMNode) -> [OSMNode] {
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        
        var queue = PriorityQueue<OSMNode>(order: { (lhs, rhs) -> Bool in
            return (distances[lhs] ?? Double.infinity) > (distances[rhs] ?? Double.infinity)
        })
        
        distances[source] = 0.0
        for (_, node) in self.nodes {
            queue.push(node)
        }
        
        while let node = queue.pop() {
            //Check if this node is reachable based on data
            guard let distance = distances[node], distance < Double.infinity else { continue }
            //For every neighbor
            for neighbor in node.adjacent {
                let distance = distance + node.location.distance(to: neighbor.location)
                //If the new distance is less than the existing distance, update the distance and previous entry
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.push(neighbor)
                }
            }
        }
        
        var prev = destination
        var shortestPath = [OSMNode]()
        while (prev != source) {
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        return shortestPath
    }
   
    
    private func heuristicFunction(from: OSMNode, to: OSMNode) -> Double {
        return Double(sqrt(pow((from.location.cartesianCoordinate.x - to.location.cartesianCoordinate.x), 2) + pow((from.location.cartesianCoordinate.y - to.location.cartesianCoordinate.y), 2)))
    }
    
    private func aStar(source: OSMNode, destination: OSMNode) -> [OSMNode] {
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        var queue = PriorityQueue<OSMNode>(order: { (lhs, rhs) -> Bool in
            return (distances[lhs] ?? Double.infinity) > (distances[rhs] ?? Double.infinity)
        })
        
        for (_, node) in self.nodes {
            queue.push(node)
        }
        distances[source] = 0
        var nodesSearched: Int = 0
        
        while let node = queue.pop() {
            nodesSearched += 1
            guard let distance = distances[node], distance < Double.infinity else { continue }
            
            if node == destination {
                break
            }
            
            for neighbor in node.adjacent {
                let distance = distance + node.location.distance(to: neighbor.location)
                //If the new distance is less than the existing distance, update the distance and previous entry
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.push(neighbor)
                }
            }
        }
        
        var prev = destination
        var shortestPath = [OSMNode]()
        while (prev != source) {
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        
        return shortestPath
    }
    
    private func levit(source: OSMNode, destination: OSMNode) -> [OSMNode] {
        return []
    }
    
}
