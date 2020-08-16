//
//  CityCard.swift
//  Clima iOS
//
//  Created by Alfonso Gonzalez on 8/14/20.
//

import SwiftUI

struct CityCard: View {
    var city: City
    var isRemovable: Bool
    var usesAutomaticColors: Bool
    
    @State private var showingActionSheet = false
    @EnvironmentObject private var model: ClimaModel
    
    var cardColor: Color {
        if !usesAutomaticColors {
            return city.cardColor
        }
        
        return .color(for: city.weatherCode)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                .foregroundColor(cardColor)
            VStack(alignment: .leading) {
                HStack {
                    Label {
                        Text(city.currentTemp)
                    } icon: {
                        Image(weatherCode: city.weatherCode)
                    }
                    .font(.title)
                    .foregroundColor(.primary)
                    
                    Spacer()
                    
                    if isRemovable {
                        Button(action: {
                            self.showingActionSheet = true
                        }, label: {
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.title)
                                .foregroundColor(.white)
                                .opacity(0.2)
                        })
                    }
                }
                
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
        .aspectRatio(1.45, contentMode: .fit)
        .contextMenu {
            if isRemovable {
                Button(action: {
                    self.showingActionSheet = true
                }, label: {
                    Text("Delete")
                    Image(systemName: "trash")
                        .foregroundColor(.primary)
                })
            }
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("This city will be deleted from all of your iCloud devices."), buttons: [
                .destructive(Text("Delete City")) {
                    delete()
                },
                .cancel()
            ])
        }
    }
    
    func delete() {
        model.delete(city)
    }
}

struct CityCard_Previews: PreviewProvider {
    static var previews: some View {
        CityCard(city: .test, isRemovable: true, usesAutomaticColors: true)
            .preferredColorScheme(.dark)
    }
}
