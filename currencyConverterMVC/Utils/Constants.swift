//
//  Constants.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 16/05/2021.
//

import Foundation

struct Constants {
    struct api {
        static func getBaseURL() -> URL? {
            return URL(string: "https://api.exchangerate-api.com")
        }
        
        static let latestRate: String = "v4/latest"
    }
}
