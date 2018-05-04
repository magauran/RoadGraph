//
//  Constants.swift
//  RoadGraph
//
//  Created by Алексей on 12.03.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

class Constants {
    
    static let earthRadius = 6_371_000.0 // meters
    
    static var defaultPlaces: [Coordinate] {
        var places = [Coordinate]()
        
        // Пятёрочка
        places.append(Coordinate(latitude: 57.918527, longitude: 59.931416))
        
        // Мегамарт
        places.append(Coordinate(latitude: 57.915175, longitude: 59.948582))
        
        // Атмосфера
        places.append(Coordinate(latitude: 57.876333, longitude: 59.943719))
        
        // Монетка
        places.append(Coordinate(latitude: 57.914003, longitude: 59.973878))
        
        // Кировский
        places.append(Coordinate(latitude: 57.916623, longitude: 59.967860))
        
        // Спутник
        places.append(Coordinate(latitude: 57.925079, longitude: 60.102157))
        
        // Купеческий
        places.append(Coordinate(latitude: 57.927860, longitude: 59.962969))
        
        // Кировский
        places.append(Coordinate(latitude: 57.937770, longitude: 59.994272))
        
        // Лента
        places.append(Coordinate(latitude: 57.875737, longitude: 60.017955))
        
        // Алтайский
        places.append(Coordinate(latitude: 57.921081, longitude: 60.060960))
        
        return places
    }
    
}
