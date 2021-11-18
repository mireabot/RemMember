//
//  ClientInfoModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import Combine
import CoreLocation

struct AddressItem {
    let address: String
    let location: CLLocationCoordinate2D
}

enum ClientInfoAddAddressError: Error {
    case undefined
}


class ClientInfo: NSObject, ObservableObject {
    
    //    Client adress data
    @State var street = ""
    @State var comment = ""
    
    
    //    Client adresses list
    @Published var adresses = [Adress_Model]()
    
    func addAddress(_ address: AddressItem, comment: String, isCurrent: Bool) -> AnyPublisher<Bool, ClientInfoAddAddressError> {
        return Future<Bool, ClientInfoAddAddressError> { [weak self] promise in
            guard let self = self else { return }
            let db = Firestore.firestore()
            let data: [String: Any] = [
                "client_id": Auth.auth().currentUser!.uid,
                "client_street": address.address,
                "client_comment": comment,
                "is_current": isCurrent,
            ]
            db.collection("Client_Adresses").document(self.randomString(length: 20)).setData(data) { error in
                if error != nil {
                    promise(.failure(.undefined))
                } else {
                    promise(.success(true))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    
    func addAdress(street: String, comment: String, current: Bool){
        
        let db = Firestore.firestore()
        
        // add new client adress
        
        db.collection("Client_Adresses").document(randomString(length: 20)).setData([
            
            "client_id": Auth.auth().currentUser!.uid,
            "client_street": street ,
            "client_comment": comment,
            "is_current": current,
            
        ]) { (err) in
            
            if err != nil{
                return
            }
            print("success")
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        print( String((0..<length).map{ _ in letters.randomElement()! }))
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func fetchClientAdress(client: String){
        
        let db = Firestore.firestore()
        
        db.collection("Client_Adresses").whereField("client_id", isEqualTo: client).addSnapshotListener { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.adresses = itemData.documents.compactMap({ (doc) -> Adress_Model? in
                
                let id = doc.documentID
                let client_id = doc.get("client_id") as! String
                let street = doc.get("client_street") as! String
                let comment = doc.get("client_comment") as! String
                let current = doc.get("is_current") as! Bool
                
                return Adress_Model(id: id, client_street: street, client_comment: comment,client_id: client_id, is_current: current)
            })
        }
    }
    func makeCurrentAdress(current: Bool, street: String){
        
        let ref = Firestore.firestore()
        
        ref.collection("Client_Adresses").whereField("client_street", isEqualTo: street).getDocuments(){ (q, err) in
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
                document?.reference.updateData(["is_current" : current])
            }
        }
    }
}




//UserDefaults.standard.setValue(self.street, forKey: "ClientStreet")
//UserDefaults.standard.setValue(self.apt, forKey: "ClientApt")
//UserDefaults.standard.setValue(self.pad, forKey: "ClientPad")
//UserDefaults.standard.setValue(self.floor, forKey: "ClientFloor")
//UserDefaults.standard.setValue(self.house, forKey: "ClientHouse")

