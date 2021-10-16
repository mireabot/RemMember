//
//  UserViewModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase


class UserView: ObservableObject {
    @Published var history = [Orderhistory]()
    @Published var users: UserModel = .empty
    @Published var errorMessage: String?
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    private var db = Firestore.firestore()
    
    func fetchAndMap() {
        fetchBook(documentId: userID ?? "")
    }
    
    private func fetchBook(documentId: String) {
        let docRef = db.collection("Users").document(documentId)
        
        docRef.addSnapshotListener { document, error in
            if let error = error as NSError? {
                self.errorMessage = "Error getting document: \(error.localizedDescription)"
            }
            else {
                let result = Result { try document?.data(as: UserModel.self) }
                switch result {
                case .success(let book):
                    if let book = book {
                        // A Book value was successfully initialized from the DocumentSnapshot.
                        self.users = book
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
    func fetchOrderHistory(client_id: String) {
        db.collection("Orders_History").whereField("client_ID", isEqualTo: client_id).whereField("status", isEqualTo: "Завершен").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
          
        self.history = documents.compactMap { queryDocumentSnapshot -> Orderhistory? in
          return try? queryDocumentSnapshot.data(as: Orderhistory.self)
        }
      }
    }
    func createUser(bonus: Int){
        
        let db = Firestore.firestore()
        let name  = UserDefaults.standard.string(forKey: "ClientName")!
        let phone = UserDefaults.standard.string(forKey: "Clientnumber")!
//        let retrive4  = UserDefaults.standard.string(forKey: "ClientStreet")!
//        let retrive5  = UserDefaults.standard.string(forKey: "ClientApt")!
//        let retrive6  = UserDefaults.standard.string(forKey: "ClientPad")!
//        let retrive7  = UserDefaults.standard.string(forKey: "ClientFloor")!
//       let retrive8  = UserDefaults.standard.string(forKey: "ClientHouse")!
        // creating dict of adress...
        
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            
            "user_bonuses": bonus,
            "user_phone": phone,
            "user_name": name,
            "user_orders": 0,
            "current_adress": "",
            "user_id" : Auth.auth().currentUser!.uid
            
        ]) { (err) in
            
            if err != nil {
                
                return
            }
            print("success User add")
        }
    }
    func setCurrentAdress(adress: String){
        
        let ref = Firestore.firestore()
        
        ref.collection("Users").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid).getDocuments(){ (q, err) in
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            /*  else if q!.documents.count != 1{
             print(err!.localizedDescription)
             return
             } */
            else {
                let document = q!.documents.first
                document?.reference.updateData(["current_adress" : adress])
            }
        }
    }
}

