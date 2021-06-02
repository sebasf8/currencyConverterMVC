//
//  Errors.swift
//  Currencies
//
//  Created by Sebastian Fernandez on 02/06/2021.
//

import Foundation

enum NetworkingError: Error {
    case malformedUrl
    case noResponse
    case parsingError
}
