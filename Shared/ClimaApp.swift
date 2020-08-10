//
//  ClimaApp.swift
//  Shared
//
//  Created by Alfonso Gonzalez on 7/21/20.
//

import SwiftUI

@main
struct ClimaApp: App {
    @StateObject private var model = ClimaModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
