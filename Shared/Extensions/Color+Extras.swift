//
//  Color+Random.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/1/20.
//

import SwiftUI

#if canImport(UIKit)
    import UIKit
    typealias NativeColor = UIColor
#elseif canImport(AppKit)
    import AppKit
    typealias NativeColor = NSColor
#endif

extension Color {
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0

        guard NativeColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }

        return (r, g, b, o)
    }
}


extension Color {
    static func random() -> Color {
        return randomCollection.randomElement()!
    }
    
    static let randomCollection: [Color] = [
        .red,
        .deepOrange,
        .orange,
        .amber,
        .lightGreen,
        .springGreen,
        .teal,
        .blue,
        .indigo,
        .purple,
        .actualPink,
        .watermelon,
        .gray,
        .resedaGreen,
        .lightBrown
    ]
    
    static let silver = Color(red: 0.74, green: 0.74, blue: 0.74)
    static let maroon = Color(red: 0.63, green: 0.17, blue: 0.35)
    static let deepOrange = Color(red: 0.94, green: 0.42, blue: 0.0)
    static let amber = Color(red: 0.98, green: 0.66, blue: 0.15)
    static let persianGreen = Color(red: 0, green: 0.6, blue: 0.6)
    static let springGreen = Color(red: 0, green: 0.9, blue: 0.6)
    static let lightGreen = Color(red: 0.49, green: 0.70, blue: 0.26)
    static let teal = Color(red: 0.15, green: 0.65, blue: 0.60)
    static let indigo = Color(red: 0.36, green: 0.42, blue: 0.75)
    static let actualPink = Color(red: 0.92, green: 0.50, blue: 0.99)
    static let watermelon = Color(red: 1.00, green: 0.53, blue: 0.61)
    static let resedaGreen = Color(red: 0.63, green: 0.70, blue: 0.64)
    static let lightBrown = Color(red: 0.63, green: 0.53, blue: 0.50)
}
