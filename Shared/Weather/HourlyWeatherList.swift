//
//  HourlyWeatherList.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/7/20.
//

import SwiftUI

struct HourlyWeatherList: View {
    var hourlyForecasts: [HourlyWeatherEntry]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(hourlyForecasts) { forecast in
                    HourlyWeatherCard(hourlyForecast: forecast)
                }
            }
        }
    }
}

struct HourlyWeatherList_Previews: PreviewProvider {
    static var previews: some View {
        HourlyWeatherList(hourlyForecasts: [.fallback])
    }
}
