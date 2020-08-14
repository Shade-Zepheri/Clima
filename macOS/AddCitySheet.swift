//
//  AddCitySheet.swift
//  Clima macOS
//
//  Created by Alfonso Gonzalez on 8/14/20.
//

import SwiftUI

struct AddCitySheet: View {
    @Binding var showSheet: Bool

    @State private var isEditing = false
    @StateObject private var suggester = LocationSuggester()
    @EnvironmentObject private var model: ClimaModel
    
    var body: some View {
        VStack {
            Text("Enter city, zip code, or airport location")
                .font(.footnote)
                .padding(.top)
            HStack {
                TextField("Search", text: $suggester.locationText) { editing in
                    isEditing = editing
                } onCommit: {
                    
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
                .overlay(
                    HStack {
                        Spacer()
                        
                        if isEditing {
                            Button(action: {
                                suggester.locationText = ""
                            }, label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(7)
                            })
                        }
                    }
                )
                
                Button(action: {
                    showSheet.toggle()
                }, label: {
                    Text("Cancel")
                })
            }
            .padding()
            
            SuggestionsList(showSheet: $showSheet, suggester: suggester)
                .environmentObject(model)
            
            Spacer()
        }
    }
}

struct AddCitySheet_Previews: PreviewProvider {
    static var previews: some View {
        AddCitySheet(showSheet: .constant(false))
            .environmentObject(ClimaModel())
    }
}
