//
//  Image+Weather.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/5/20.
//

import SwiftUI

extension Image {
    private static func systemName(for code: String) -> String {
        switch code {
        case "01d":
            return "sun.max.fill"
        case "01n":
            return "moon.fill"
        case "02d":
            return "cloud.sun.fill"
        case "02n":
            return "cloud.moon.fill"
        case "03d", "03n":
            return "cloud.fill"
        case "04d", "04n":
            return "smoke.fill"
        case "09d", "09n":
            return "cloud.rain.fill"
        case "10d":
            return "cloud.sun.rain.fill"
        case "10n":
            return "cloud.moon.rain.fill"
        case "11d", "11n":
            return "cloud.bolt.fill"
        case "13d", "13n":
            return "cloud.snow.fill"
        case "50d", "50n":
            return "cloud.fog.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    init(weatherCode: String) {
        self.init(systemName: Self.systemName(for: weatherCode))
    }
}
