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
    
    func shortestPath(source: OSMNode, destination: OSMNode, algorithm: Algorithm = .Dijkstra) -> ([OSMNode], Double) {
        
        switch algorithm {
        case .Dijkstra:
            return dijkstra(source: source, destination: destination)
        case .AStar:
            return aStar(source: source, destination: destination)
        case .Levit:
            return levit(source: source, destination: destination)
        }
        
    }
    
    private func dijkstra(source: OSMNode, destination: OSMNode) -> ([OSMNode], Double) {
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
        var length = 0.0
        var shortestPath = [OSMNode]()
        while (prev != source) {
            length += prev.location.distance(to: previous[prev]!.location)
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        return (shortestPath, length)
    }
   
    
    private func heuristicFunction(from: OSMNode, to: OSMNode) -> Double {
        return Double(sqrt(pow((from.location.cartesianCoordinate.x - to.location.cartesianCoordinate.x), 2) + pow((from.location.cartesianCoordinate.y - to.location.cartesianCoordinate.y), 2)))
    }
    
    private func aStar(source: OSMNode, destination: OSMNode) -> ([OSMNode], Double) {
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
        var length = 0.0
        var shortestPath = [OSMNode]()
        while (prev != source) {
            length += prev.location.distance(to: previous[prev]!.location)
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        
        return (shortestPath, length)
    }
    
    private enum Status {
        case notYet
        case now
        case already
    }
    
    private func levit(source: OSMNode, destination: OSMNode) -> ([OSMNode], Double) {
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        var status = Dictionary<OSMNode, Status>()
        
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
                if status[neighbor] == nil {
                    status[neighbor] = .notYet
                }
                switch (status[neighbor]!) {
                case .notYet:
                    status[neighbor] = .now
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.push(neighbor)
                    }
                    break
                case .now:
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.push(neighbor)
                    }
                    break
                default:
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        status[neighbor] = .now
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.push(neighbor)
                    }
                    break
                }
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.push(neighbor)
                }
                status[neighbor] = .already
            }
            
        }
        
        var prev = destination
        var length = 0.0
        var shortestPath = [OSMNode]()
        while (prev != source) {
            length += prev.location.distance(to: previous[prev]!.location)
            shortestPath.append(prev)
            prev = previous[prev]!
        }
        shortestPath.append(prev)
        return (shortestPath, length)
    }
    
}
