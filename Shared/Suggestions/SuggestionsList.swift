//
//  SuggestionsList.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/8/20.
//

import SwiftUI

struct SuggestionsList: View {
    @Binding var showSheet: Bool
    @ObservedObject var suggester: LocationSuggester
    @EnvironmentObject private var model: ClimaModel
    
    var body: some View {
        List(suggester.suggestions, id:\.self) { suggestion in
            Button(action: {
                model.appendCity(from: suggestion.completion)
                showSheet.toggle()
            }, label: {
                Text(suggestion.label)
            })
        }
    }
}

struct SuggestionsList_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionsList(showSheet: .constant(false), suggester: LocationSuggester())
    }
}
