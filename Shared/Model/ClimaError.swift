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

extension ClimaError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .statusCode:
            return NSLocalizedString("URL Response code was not 200.", comment: "")
        case .decoding:
            return NSLocalizedString("Couldn't decode JSON into model.", comment: "")
        case .invalidURL:
            return NSLocalizedString("Generated API URL is invalid.", comment: "")
        case .reverseGeocoding:
            return NSLocalizedString("Failed to reverse geocode coordinates.", comment: "")
        case .forwardGeocoding:
            return NSLocalizedString("Couldn't retrieve coordinates for desired location.", comment: "")
        case .noSavedCities:
            return NSLocalizedString("No cities stored in database.", comment: "")
        case .other(let error):
            return NSLocalizedString("Other error: \(error.localizedDescription)", comment: "")
        }
    }
}
