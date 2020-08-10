//
//  LocationSuggester.swift
//  Clima
//
//  Created by Alfonso Gonzalez on 8/8/20.
//

import Combine
import CoreLocation
import MapKit

class LocationSuggester: NSObject, ObservableObject {
    struct Suggestion: Hashable {
        var label: String
        var completion: MKLocalSearchCompletion
        
        static func == (lhs: Suggestion, rhs: Suggestion) -> Bool {
            return lhs.completion == rhs.completion
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(completion)
        }
    }
    
    @Published var locationText = ""
    @Published var suggestions:[Suggestion] = []
    
    private var cancellable: AnyCancellable?
    private var typedLocationPublisher: AnyPublisher<String, Never> {
        $locationText
            .debounce(for: 0.2, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    private let searchCompleter = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        
        searchCompleter.delegate = self
  
        cancellable = typedLocationPublisher
            .receive(on: DispatchQueue.main)
            .sink { string in
                self.searchCompleter.queryFragment = string
            }
    }
}

extension LocationSuggester: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = completer.results
        
        suggestions = results.map {
            Suggestion(label: $0.title, completion:$0)
        }
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        suggestions = []
    }
}
