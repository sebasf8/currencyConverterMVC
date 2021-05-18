//
//  RateResponse.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 18/05/2021.
//

import Foundation

struct RateResponse: Codable {
    var base: String?
    var date: Date?
    var rates: [String: Double]
}
