//
//  HourlyWeatherCard.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/7/20.
//

import SwiftUI

struct HourlyWeatherCard: View {
    var hourlyForecast: HourlyWeatherEntry
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                .foregroundColor(.silver)
            
            VStack {
                Text(hourlyForecast.timestamp)
                
                Spacer(minLength: 5)
                
                Text(hourlyForecast.currentTemp)
                
                Spacer(minLength: 10)
                
                Image(weatherCode: hourlyForecast.weather[0].icon)
            }
            .padding()
        }
        .padding(5)
        .shadow(radius: 2)
        .frame(minWidth: 100, maxWidth: 120, minHeight: 100, maxHeight: 150)
    }
}

struct HourlyWeatherCard_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherCard(hourlyForecast: .fallback)
    }
}
