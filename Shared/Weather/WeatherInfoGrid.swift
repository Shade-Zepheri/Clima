//
//  WeatherInfoGrid.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/7/20.
//

import SwiftUI

struct WeatherInfoGrid: View {
    var city: City
    
    var rows = [
        GridItem(.flexible(minimum: 110, maximum: 200)),
        GridItem(.flexible(minimum: 110, maximum: 200))
    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                InfoCard(color: .green, info: "40%", description: "Chance of Rain", iconName: "drop.fill")

                InfoCard(color: .red, info: city.feelsLikeTemp, description: "Feels Like", iconName: "thermometer")
                
                InfoCard(color: .orange, info: city.windSpeed, description: "Wind", iconName: "wind")

                InfoCard(color: .blue, info: "\(city.humidity)%", description: "Humidity", iconName: "drop.fill")
                
                InfoCard(color: .persianGreen, info: city.precipitationPercentage, description: "Precipitation", iconName: "cloud.rain.fill")
                
                InfoCard(color: .maroon, info: city.sunriseTime, description: "Sunrise", iconName: "drop.fill")
                
                InfoCard(color: .purple, info: city.sunsetTime, description: "Sunset", iconName: "drop.fill")
                
                InfoCard(color: .yellow, info: city.pressure, description: "Pressure", iconName: "gauge")
                
                InfoCard(color: .gray, info: city.visibility, description: "Visibility", iconName: "binoculars.fill")
                
                InfoCard(color: .springGreen, info: String(format: "%.1f", city.uvi), description: "UV Index", iconName: "sun.max.fill")
            }
        }
    }
}

struct WeatherInfoGrid_Previews: PreviewProvider {
    static var previews: some View {
        WeatherInfoGrid(city: .test)
    }
}

// sunrise-
// sunset-
// chance of rain-
// humidity-
// wind-
// feels like-
// precipitation-
// pressue-
// visibility-
// uvi-
// air quality index
// air quality
