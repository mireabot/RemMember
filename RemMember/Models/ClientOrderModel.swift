//
//  ClientOrderModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

class OrderTestModel: ObservableObject {
    @Published var book: OrderTest = .empty
    @Published var errorMessage: String?
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    private var db = Firestore.firestore()
    
    func fetchAndMap() {
        fetchBook(documentId: userID ?? "")
    }
    
    private func fetchBook(documentId: String) {
        let docRef = db.collection("Orders").document(documentId)
        
        docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
                let result = Result { try document?.data(as: OrderTest.self) }
                switch result {
                case .success(let book):
                    if let book = book {
                        // A Book value was successfully initialized from the DocumentSnapshot.
                        self.book = book
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

