//
//  RoadGraph+ShortestPath.swift
//  RoadGraph
//
//  Created by Алексей on 07.04.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

public enum ShortestPathAlgorithm {
    case Dijkstra
    case AStar
    case Levit
}


extension RoadGraph {
    
    func shortestPath(source: OSMNode, destination: OSMNode, algorithm: ShortestPathAlgorithm = .Dijkstra) -> ([OSMNode], Double) {
        
        switch algorithm {
        case .Dijkstra:
            return dijkstra(source: source, destination: destination)
        case .AStar:
            return aStar(source: source, destination: destination, heuristic: .Chebyshev)
        case .Levit:
            return levit(source: source, destination: destination)
        }
        
    }
    
    private func dijkstra(source: OSMNode, destination: OSMNode) -> ([OSMNode], Double) {
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        
        var queue = PriorityQueue([(node: source, priority: 0)]) {
            return $0.priority < $1.priority
        }
        
        distances[source] = 0.0
        
        while !queue.isEmpty {
            let node = queue.dequeue().node
            //Check if this node is reachable based on data
            guard let distance = distances[node], distance < Double.infinity else { continue }
            //For every neighbor
            for neighbor in node.adjacent {
                let distance = distance + node.location.distance(to: neighbor.location)
                //If the new distance is less than the existing distance, update the distance and previous entry
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.enqueue((node: neighbor, priority: Int(distance)))
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
    
    private func aStar(source: OSMNode, destination: OSMNode, heuristic: Heuristic) -> ([OSMNode], Double) {
        var distances = Dictionary<OSMNode, Double>()
        var previous = Dictionary<OSMNode, OSMNode>()
        
        var queue = PriorityQueue([(node: source, priority: 0)]) {
            return $0.priority < $1.priority
        }
        
        distances[source] = 0
        var nodesSearched: Int = 0
        
        while !queue.isEmpty {
            let node = queue.dequeue().node
            nodesSearched += 1
            guard let distance = distances[node], distance < Double.infinity else { continue }
            
            if node == destination {
                break
            }
            
            for neighbor in node.adjacent {
                let distance = distance + node.location.distance(to: neighbor.location)
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.enqueue((node: neighbor, priority: Int(distance + heuristic.distance(from: destination, to: neighbor))))
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
        
        var queue = PriorityQueue([(node: source, priority: 0)]) {
            return $0.priority < $1.priority
        }
        
        distances[source] = 0.0
        
        while !queue.isEmpty {
            let node = queue.dequeue().node
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
                        queue.enqueue((node: neighbor, priority: Int(distance)))
                    }
                    break
                case .now:
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.enqueue((node: neighbor, priority: Int(distance)))
                    }
                    break
                default:
                    if (distances[neighbor] ?? Double.infinity) > distance {
                        status[neighbor] = .now
                        distances[neighbor] = distance
                        previous[neighbor] = node
                        queue.enqueue((node: neighbor, priority: Int(distance)))
                    }
                    break
                }
                if (distances[neighbor] ?? Double.infinity) > distance {
                    distances[neighbor] = distance
                    previous[neighbor] = node
                    queue.enqueue((node: neighbor, priority: Int(distance)))
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
