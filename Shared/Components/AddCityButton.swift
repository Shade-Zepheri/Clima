//
//  AddCityButton.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/2/20.
//

import SwiftUI

struct AddCityButton: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: {
            showSheet = true
        }, label: {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15.0, style: .continuous)
                    .stroke(lineWidth: 1.0)
                
                VStack(alignment: .leading) {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                    
                    Spacer(minLength: 20)
                    
                    Text("Add City")
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                .padding()
            }
            .aspectRatio(1.45, contentMode: .fit)
            .padding(5)
            .foregroundColor(.accentColor)
            .shadow(radius: 3.0)
        })
    }
}

struct AddCityButton_Previews: PreviewProvider {
    static var previews: some View {
        AddCityButton(showSheet: .constant(false))
    }
}
