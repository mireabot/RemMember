//
//  SearchAddressViewModel.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import Combine

final class SearchAddressViewModel: ObservableObject {
    
    @Published var items: [LocalSearchCompleterItem] = []
    @Published var text: String = ""
    
    private let localSearchCompleter = LocalSearchCompleter()
    
    private var cancellables : Set<AnyCancellable> = []
    
    init() {
        $text.sink { [weak self] text in
            guard let self = self else { return }
            self.localSearchCompleter.search(text).sink { error in

            } receiveValue: { items in
                self.items = items
            }.store(in: &self.cancellables)
        }.store(in: &cancellables)
    }

}
