//
//  ClimaError.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/2/20.
//

import Foundation

enum ClimaError: Error {
    case statusCode
    case decoding
    case invalidURL
    case reverseGeocoding
    case forwardGeocoding
    case noSavedCities
    case other(Error)
    
    static func map(_ error: Error) -> ClimaError {
        return (error as? ClimaError) ?? .other(error)
    }
}
