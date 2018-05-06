//
//  GeneticAlgorithm.swift
//  RoadGraph
//
//  Created by Алексей on 16.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class GeneticAlgorithm {
    var populationSize = 500
    let mutationProbability = 0.015
    
    let nodes: [OSMNode]
    var onNewGeneration: ((Way, Int) -> ())?
    
    private var population: [Way] = []
    
    init(withCities: [OSMNode]) {
        self.nodes = withCities
        self.population = self.randomPopulation(fromCities: self.nodes)
    }
    
    private func randomPopulation(fromCities: [OSMNode]) -> [Way] {
        var result: [Way] = []
        for _ in 0..<populationSize {
            let randomCities = fromCities.shuffle()
            result.append(Way(nodes: randomCities))
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
        generation.forEach { (route) in
            if currentFitness <= fitness {
                currentFitness += route.fitness(with: totalDistance)
                result = route
            }
        }
        
        return result
    }
    
    private func produceOffspring(firstParent: Way, secondParent: Way) -> Way {
        let slice: Int = Int(arc4random_uniform(UInt32(firstParent.nodes.count)))
        var cities: [OSMNode] = Array(firstParent.nodes[0..<slice])
        
        var idx = slice
        while cities.count < secondParent.nodes.count {
            let city = secondParent.nodes[idx]
            if cities.contains(city) == false {
                cities.append(city)
            }
            idx = (idx + 1) % secondParent.nodes.count
        }
        
        return Way(nodes: cities)
    }
    
    private func mutate(child: Way) -> Way {
        if self.mutationProbability >= Double(Double(arc4random()) / Double(UINT32_MAX)) {
            let firstIdx = Int(arc4random_uniform(UInt32(child.nodes.count)))
            let secondIdx = Int(arc4random_uniform(UInt32(child.nodes.count)))
            var cities = child.nodes
            cities.swapAt(firstIdx, secondIdx)
            
            return Way(nodes: cities)
        }
        
        return child
    }
}


