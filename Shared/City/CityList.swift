//
//  CityList.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/23/20.
//

import SwiftUI

struct CityList: View {
    var cities: [City]
    
    @State private var showingSheet = false
    @State private var selection: City?
    @EnvironmentObject private var model: ClimaModel
    
    var columns = [
        GridItem(.flexible(minimum: 150)),
        GridItem(.flexible(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                Section(header: Text("Locations")) {
                    ForEach(cities) { city in
                        NavigationLink(
                            destination: CityView(city: city),
                            tag: city,
                            selection: $selection
                        ) {
                            CityCard(city: city)
                        }
                        .tag(city)
                        .disabled(city.isFallback())
                    }

                    AddCityButton(showSheet: $showingSheet)
                }
            }
        }
        .navigationTitle("Weather")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showingSheet.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            AddCitySheet(showSheet: $showingSheet)
                .environmentObject(model)
        }
    }
}

struct CityList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                CityList(cities: [.fallbackCity, .test])
                    .environmentObject(ClimaModel())
            }
            .preferredColorScheme(scheme)
        }
    }
}
