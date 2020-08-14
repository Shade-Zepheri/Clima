//
//  ContentView.swift
//  Shared
//
//  Created by Alfonso Gonzalez on 7/21/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: ClimaModel
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: CityView(city: model.currentCity)) {
                    CityCard(color: .silver, city: model.currentCity, isRemovable: false)
                }
                .disabled(model.currentCity.isFallback())
                .frame(maxHeight: 175)
                .padding()
                
                Divider()
                
                CityList()
            }
            
            Text("Select a City")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ClimaModel())
    }
}
