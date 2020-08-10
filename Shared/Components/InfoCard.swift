//
//  InfoCard.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/4/20.
//

import SwiftUI

struct InfoCard: View {
    var color: Color
    var info: String
    var description: String
    var iconName: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                .foregroundColor(color)

            VStack(alignment: .leading) {
                HStack {
                    Label(description, systemImage: iconName)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text(info)
                    .font(.title)
                    .fontWeight(.medium)
            }
            .padding()
                
        }
        .padding(5)
        .shadow(radius: 2)
        .aspectRatio(1.618, contentMode: .fit)
    }
}

struct InfoCard_Previews: PreviewProvider {
    static var previews: some View {
        InfoCard(color: .blue, info: "10", description: "Humidity", iconName: "thermometer.sun")
    }
}
