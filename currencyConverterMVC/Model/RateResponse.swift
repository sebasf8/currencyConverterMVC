//
//  RateResponse.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 18/05/2021.
//

import Foundation

protocol Rate {
    var base: String? { get set }
    var date: Date? { get set }
    var rates: [String: Double] { get set }
    
    func convert(ammount: Double, to: String) -> Double
}

struct RateResponse: Codable, Rate {
    var base: String?
    var date: Date?
    var rates: [String: Double]
    
    func convert(ammount: Double, to currency: String) -> Double {
        if let convertionRate = rates[currency] {
            return ammount * convertionRate
        }
        
        return 0.0
    }
}
