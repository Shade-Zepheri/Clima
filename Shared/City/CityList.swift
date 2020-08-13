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
                        NavigationLink(destination: CityView(city: city)) {
                            CityCard(city: city, isRemovable: true)
                        }
                        .disabled(city.isFallback())
                    }

                    AddCityButton(showSheet: $showingSheet)
                }
            }
            .padding(7)
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
