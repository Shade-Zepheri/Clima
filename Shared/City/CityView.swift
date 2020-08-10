//
//  CityView.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/22/20.
//

import SwiftUI

struct CityView: View {
    var city: City
    
    var body: some View {
        VStack {
            Text(city.currentTemp)
                .font(.system(size: 80))
                .fontWeight(.bold)
                .padding()

            Label {
                Text(city.condition)
            } icon: {
                Image(weatherCode: city.weatherCode)
            }
            .foregroundColor(.secondary)

            HStack {
                HStack {
                    Text(city.dailyHigh)
                    Text(city.dailyLow)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding([.top, .horizontal])

            Divider()

            WeatherInfoGrid(city: city)
            
            Divider()
            
            HourlyWeatherList(hourlyForecasts: city.weatherData.hourly)
            
            Spacer()
            
        }
        .navigationTitle(city.locality)
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            NavigationView {
                CityView(city: .test)
            }
            .preferredColorScheme(scheme)
        }
    }
}
