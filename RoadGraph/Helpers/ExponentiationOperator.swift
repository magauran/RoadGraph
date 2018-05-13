//
//  ExponentiationOperator.swift
//  RoadGraph
//
//  Created by Алексей on 18.05.2018.
//  Copyright © 2018 Алексей. All rights reserved.
//

import Foundation

precedencegroup ExponentiationPrecedence {
    associativity: right
    higherThan: MultiplicationPrecedence
}

infix operator ** : ExponentiationPrecedence

func ** (_ base: Double, _ exp: Double) -> Double {
    return pow(base, exp)
}

func ** (_ base: Double, _ exp: Int) -> Double {
    return pow(base, Double(exp))
}

func ** (_ base: CGFloat, _ exp: Int) -> Double {
    return pow(Double(base), Double(exp))
}
