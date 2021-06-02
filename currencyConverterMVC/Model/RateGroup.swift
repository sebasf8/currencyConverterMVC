//
//  RateGroup.swift
//  Currencies
//
//  Created by Sebastian Fernandez on 02/06/2021.
//

import Foundation

protocol RateGroup {
    var base: String? { get set }
    var date: Date? { get set }
    var rates: [String: Double] { get set }
    
    func convert(amount: Double, to: String) -> Double
}

extension RateGroup {
    func convert(amount: Double, to currency: String) -> Double {
        guard let convertionRate = rates[currency] else {
            return 0.0
        }
        
        return amount * convertionRate
    }
}
