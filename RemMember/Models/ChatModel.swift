//
//  ChatModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class ChatModel: ObservableObject{
    
    @Published var txt = ""
    @Published var msgs : [MsgModel] = []
    @AppStorage("ClientName") var user = ""
    let ref = Firestore.firestore()
    
    func onAppear(){
        
        // Checking whether user is joined already....
        
        if user == ""{
            // Join Alert...
            
            UIApplication.shared.windows.first?.rootViewController?.present(alertView(), animated: true)
        }
    }
    
    func alertView()->UIAlertController{
        
        let alert = UIAlertController(title: "Join Chat !!!", message: "Enter Nick Name", preferredStyle: .alert)
        
        alert.addTextField { (txt) in
            txt.placeholder = "eg Kavsoft"
        }
        
        let join = UIAlertAction(title: "Join", style: .default) { (_) in
            
            // checking for empty click...
            
            let user = alert.textFields![0].text ?? ""
            
            if user != ""{
                
                self.user = user
                return
            }
            
            // repromiting alert view...
            
            UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true)
        }
        
        alert.addAction(join)
        
        return alert
    }
    
    func readAllMsgs(){
        
        ref.collection("Msgs").order(by: "timeStamp", descending: false).addSnapshotListener { (snap, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else{return}
            
            data.documentChanges.forEach { (doc) in
                
                // adding when data is added...
                
                if doc.type == .added{
                    
                    let msg = try! doc.document.data(as: MsgModel.self)!
                    
                    DispatchQueue.main.async {
                        self.msgs.append(msg)
                    }
                }
            }
        }
    }
    func readMsgs(ID : String){
        
        ref.collection("Msgs").whereField("userID", isEqualTo: ID).addSnapshotListener { (snap, err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
            guard let data = snap else{return}
            
            data.documentChanges.forEach { (doc) in
                
                // adding when data is added...
                
                if doc.type == .added{
                    
                    let msg = try! doc.document.data(as: MsgModel.self)!
                    
                    DispatchQueue.main.async {
                        self.msgs.append(msg)
                    }
                }
            }
        }
    }
    func writeMsg(){
        
        let msg = MsgModel(msg: txt, user: user, userID: Auth.auth().currentUser!.uid, timeStamp: Date())
        
        let _ = try! ref.collection("Msgs").addDocument(from: msg) { (err) in
            
            if err != nil{
                print(err!.localizedDescription)
                return
            }
            
        }
        
        self.txt = ""
    }
}




// For Onchange...
struct MsgModel: Codable,Identifiable,Hashable {
    
    @DocumentID var id : String?
    var msg : String
    var user : String
    var userID : String
    var timeStamp: Date
    
    enum CodingKeys: String,CodingKey {
        case id
        case msg
        case user
        case userID
        case timeStamp
    }
}
