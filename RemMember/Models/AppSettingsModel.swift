//
//  AppSettingsModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 17.10.2021.
//

import Foundation
import Firebase
import SwiftUI
import FirebaseFirestoreSwift


struct AppSettings : Codable, Hashable {
    @DocumentID var id: String?
    var delivery_time : String?
    var service_out: Bool?
    var admin_id: String?
    var master_id: String?
}

extension AppSettings {
    static let empty = AppSettings(id: "", delivery_time: "30", service_out: false, admin_id: "", master_id: "")
    static let full = AppSettings(id: "", delivery_time: "45", service_out: true,admin_id: "",master_id: "")
}



class AppSettingsModel: ObservableObject {
    @Published var app: AppSettings = .empty
    @Published var errorMessage: String?
    private var db = Firestore.firestore()
    
    func fetchAndMapSettings() {
        fetchStats(documentId: "7DDb6ZSc2fGQAntuWK3x")
    }
    
    private func fetchStats(documentId: String) {
        let docRef = db.collection("AppSettings").document(documentId)
        
        docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
                let result = Result { try document?.data(as: AppSettings.self) }
                switch result {
                case .success(let book):
                    if let book = book {
                        // A Book value was successfully initialized from the DocumentSnapshot.
                        self.app = book
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

