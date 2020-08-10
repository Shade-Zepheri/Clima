//
//  CityRow.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 7/22/20.
//

import SwiftUI

struct CityCard: View {
    var city: City
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                .foregroundColor(.red)
            VStack(alignment: .leading) {
                Label {
                    Text(city.currentTemp)
                } icon: {
                    Image(weatherCode: city.weatherCode)
                }
                .font(.title)
                .foregroundColor(.primary)
                
                Spacer()
                
                Text(city.locality)
                    .font(.title3)
                    .foregroundColor(.primary)
                Text(city.condition)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .padding(5)
        .shadow(radius: 2.0)
        .aspectRatio(1.4, contentMode: .fit)
    }
}

struct CityRow_Previews: PreviewProvider {
    static var previews: some View {
        CityCard(city: .test)
    }
}
