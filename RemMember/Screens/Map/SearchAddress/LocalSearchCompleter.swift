//
//  LocalSearchCompleter.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import Combine
import MapKit

struct LocalSearchCompleterItem: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
}

final class LocalSearchCompleter: NSObject {
    
    @Published var items : [LocalSearchCompleterItem] = []
    @Published var text = ""
    
    private let localSearchCompleter = MKLocalSearchCompleter()
    
    private var promise: ((Result<[LocalSearchCompleterItem], Error>) -> Void)?
    
    override init() {
        super.init()
        localSearchCompleter.delegate = self
    }
    
    func search(_ text: String) -> Future<[LocalSearchCompleterItem], Error> {
        return Future { promise in
            self.localSearchCompleter.queryFragment = text
            self.promise = promise
        }
    }
    
}

extension LocalSearchCompleter: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        promise?(.success(completer.results.map({ $0.localSearchCompleterItem })))
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        
    }
    
}


extension MKLocalSearchCompletion {
    
    var localSearchCompleterItem: LocalSearchCompleterItem {
        return LocalSearchCompleterItem(
            id: UUID().uuidString,
            title: title,
            subtitle: subtitle
        )
    }
    
}
