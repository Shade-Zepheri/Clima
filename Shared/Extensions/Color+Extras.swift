//
//  Color+Random.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/1/20.
//

import SwiftUI

extension Color {
    static func random() -> Color {
        let hue = Double.random(in: 0...360)
        let saturation = Double.random(in: 25...75)
        let brightness = Double.random(in: 40...60)
        return Color(hue: hue, saturation: saturation, brightness: brightness)
    }
    
    static let silver = Color(red: 0.74, green: 0.74, blue: 0.74)
    static let maroon = Color(red: 0.63, green: 0.17, blue: 0.35)
    static let persianGreen = Color(red: 0, green: 0.6, blue: 0.6)
    static let springGreen = Color(red: 0, green: 0.9, blue: 0.6)
}
