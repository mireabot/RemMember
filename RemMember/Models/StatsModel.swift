//
//  StatsModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

struct Stats : Codable, Hashable {
    @DocumentID var id: String?
    var amount : Int?
    var orders : Int?
    var users : String?
}

extension Stats {
    static let empty = Stats(id: "", amount: 0, orders: 0, users: "")
    static let sample = Stats(id: "id", amount: 1, orders: 1, users: "10")
}

class StatsModel: ObservableObject {
    @Published var stats: Stats = .empty
    @Published var errorMessage: String?
    private var db = Firestore.firestore()
    
    func fetchAndMapStats() {
        fetchStats(documentId: "t0JiZQ2oGQWXj6SCCTQJ")
    }
    
    private func fetchStats(documentId: String) {
        let docRef = db.collection("Stats").document(documentId)
        
        docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
                let result = Result { try document?.data(as: Stats.self) }
                switch result {
                case .success(let book):
                    if let book = book {
                        // A Book value was successfully initialized from the DocumentSnapshot.
                        self.stats = book
                        self.errorMessage = nil
                    }
                    else {
                        // A nil value was successfully initialized from the DocumentSnapshot,
                        // or the DocumentSnapshot was nil.
                        self.errorMessage = "Document doesn't exist."
                    }
                case .failure(let error):
                    // A Book value could not be initialized from the DocumentSnapshot.
                    switch error {
                    case DecodingError.typeMismatch(_, let context):
                        self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.valueNotFound(_, let context):
                        self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.keyNotFound(_, let context):
                        self.errorMessage = "\(error.localizedDescription): \(context.debugDescription)"
                    case DecodingError.dataCorrupted(let key):
                        self.errorMessage = "\(error.localizedDescription): \(key)"
                    default:
                        self.errorMessage = "Error decoding document: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
}

