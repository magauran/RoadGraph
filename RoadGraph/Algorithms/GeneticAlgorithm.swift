//
//  GeneticAlgorithm.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class GeneticAlgorithm {
    var populationSize = 1000
    let mutationProbability = 0.1
    
    let nodes: [OSMNode]
    let lengths: [[Double]]
    var onNewGeneration: ((Way, Int) -> ())?
    
    private var population: [Way] = []
    
    init(withCities: [OSMNode], lengths: [[Double]]) {
        self.nodes = withCities
        self.lengths = lengths
        self.population = self.randomPopulation(fromNodes: self.nodes)
    }
    
    private func randomPopulation(fromNodes: [OSMNode]) -> [Way] {
        var result: [Way] = []
        for p in 0..<populationSize {
            var randomCities = NNAlgorithm.nearestNeighbor(nodes: fromNodes, lengths: self.lengths).nodes
            randomCities.removeLast()
            if p != 0 {
                randomCities.shuffle()
            }
            var shuffledLengths = Array(repeating: Array(repeating: Double.infinity, count: lengths.count), count: lengths.count);
            for i in 0..<lengths.count - 1 {
                for j in i + 1..<lengths.count {
                    let findI = self.nodes.index(where: {$0 == randomCities[i]}) ?? 0
                    let findJ = self.nodes.index(where: {$0 == randomCities[j]}) ?? 0
                    shuffledLengths[i][j] = lengths[findI][findJ]
                    shuffledLengths[j][i] = shuffledLengths[i][j]
                }
            }
            var dist = 0.0
            for i in 0..<randomCities.count - 2 {
                dist += shuffledLengths[i][i + 1]
            }
            
            result.append(Way(nodes: randomCities, distance: dist))
        }
        return result
    }
    
    private var evolving = false
    public var generation = 1
    
    public func startEvolution() {
        evolving = true
        DispatchQueue.global().async {
            while self.evolving{
                
                let currentTotalDistance = self.population.reduce(0.0, { $0 + $1.distance })
                let sortByFitnessDESC: (Way, Way) -> Bool = { $0.fitness(with: currentTotalDistance) > $1.fitness(with: currentTotalDistance) }
                let currentGeneration = self.population.sorted(by: sortByFitnessDESC)
                
                var nextGeneration: [Way] = []
                
                for _ in 0..<self.populationSize {
                    guard
                        let parentOne = self.getParent(fromGeneration: currentGeneration, with: currentTotalDistance),
                        let parentTwo = self.getParent(fromGeneration: currentGeneration, with: currentTotalDistance)
                        else { continue }
                    
                    let child = self.produceOffspring(firstParent: parentOne, secondParent: parentTwo)
                    let finalChild = self.mutate(child: child)
                    
                    nextGeneration.append(finalChild)
                }
                self.population = nextGeneration
                
                if let bestRoute = self.population.sorted(by: sortByFitnessDESC).first {
                    self.onNewGeneration?(bestRoute, self.generation)
                }
                self.generation += 1
            }
        }
    }
    
    public func stopEvolution() {
        evolving = false
    }
    
    private func getParent(fromGeneration generation: [Way], with totalDistance: Double) -> Way? {
        let fitness = Double(arc4random()) / Double(UINT32_MAX)
        
        var currentFitness: Double = 0.0
        var result: Way?
        for route in generation {
            if currentFitness <= fitness {
                currentFitness += route.fitness(with: totalDistance)
                result = route
            }
        }
        
        return result
    }
    
    private func produceOffspring(firstParent: Way, secondParent: Way) -> Way {
        let slice: Int = Int(arc4random_uniform(UInt32(firstParent.nodes.count)))
        var offspringNodes: [OSMNode] = Array(firstParent.nodes[0..<slice])
        
        var idx = slice
        while offspringNodes.count < secondParent.nodes.count {
            let node = secondParent.nodes[idx]
            if offspringNodes.contains(node) == false {
                offspringNodes.append(node)
            }
            idx = (idx + 1) % secondParent.nodes.count
        }
        
        
        
        return Way(nodes: offspringNodes)
    }
    
    private func mutate(child: Way) -> Way {
        
        if self.mutationProbability >= Double(Double(arc4random()) / Double(UINT32_MAX)) {
            let firstIdx = Int(arc4random_uniform(UInt32(child.nodes.count)))
            let secondIdx = Int(arc4random_uniform(UInt32(child.nodes.count)))
            var nodes = child.nodes
            nodes.swapAt(firstIdx, secondIdx)
            
            child.nodes = nodes
        }
        
        var dist = 0.0
        for i in 0..<nodes.count - 2 {
            let index1 = self.nodes.index(of: child.nodes[i])!
            let index2 = self.nodes.index(of: child.nodes[i + 1])!
            dist += self.lengths[index1][index2]
        }
        
        return Way(nodes: child.nodes, distance: dist)
    }
}


