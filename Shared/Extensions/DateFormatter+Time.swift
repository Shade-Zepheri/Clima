//
//  DateFormatter+Hours.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/7/20.
//

import Foundation

extension DateFormatter {
    static let timeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}
