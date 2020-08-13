//
//  ConcreteColor.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/13/20.
//

import Foundation
import SwiftUI

public class ConcreteColor: NSObject, NSSecureCoding {
    public let red: Double
    public let green: Double
    public let blue: Double
    
    public init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        super.init()
    }
    
    public required init?(coder: NSCoder) {
        self.red = coder.decodeDouble(forKey: "red")
        self.green = coder.decodeDouble(forKey: "green")
        self.blue = coder.decodeDouble(forKey: "blue")
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(red, forKey: "red")
        coder.encode(green, forKey: "green")
        coder.encode(blue, forKey: "blue")
    }
    
    public static var supportsSecureCoding: Bool {
        return true
    }
}

extension ConcreteColor {
    convenience init(_ color: Color) {
        let components = color.components
        
        self.init(red: Double(components.red), green: Double(components.green), blue: Double(components.blue))
    }
    
    func derivedColor() -> Color {
        return Color(red: red, green: green, blue: blue)
    }
}

public class ConcreteColorTransformer: NSSecureUnarchiveFromDataTransformer {
    public override class func transformedValueClass() -> AnyClass {
        return ConcreteColor.self
    }
}

extension NSValueTransformerName {
    static let concreteColorTransformer = NSValueTransformerName(rawValue: String(describing: ConcreteColorTransformer.self))
}
