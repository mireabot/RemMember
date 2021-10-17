//
//  ChatScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import StreamChat
import Combine
import FirebaseFirestore
import SwiftUI

let dbCollection = Firestore.firestore().collection("cloudmessageDB")
let firebaseData = FirebaseData()

class FirebaseData: ObservableObject {
    var sender:String?
    @Published var didChange = PassthroughSubject<[ThreadDataType], Never>()
    @Published var data = [ThreadDataType](){
        didSet{
            didChange.send(data)
        }
    }
    
    init() {
//        readData()
    }
    
    // Reference link: https://firebase.google.com/docs/firestore/manage-data/add-data
    func createData(sender: String,msg1:String) {
        // To create or overwrite a single document
        dbCollection.document().setData(["id" : dbCollection.document().documentID,"content":msg1,"userID":sender, "date":makeToday(),"isRead":false]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("create data success")
            }
        }
    }
    
    // Reference link : https://firebase.google.com/docs/firestore/query-data/listen
    func readData() {
        dbCollection.order(by: "date").addSnapshotListener { (documentSnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("read data success")
            }
            
            documentSnapshot!.documentChanges.forEach { diff in
                // Real time create from server
                if (diff.type == .added) {
                    let msgData = ThreadDataType(id: diff.document.documentID, userID: diff.document.get("userID") as! String, content: diff.document.get("content") as! String, date: diff.document.get("date") as! String, isRead: diff.document.get("isRead") as! Bool)
                    self.data.append(msgData)
                }
                
                // Real time modify from server
                if (diff.type == .modified) {
                    self.data = self.data.map { (eachData) -> ThreadDataType in
                        var data = eachData
                        if data.id == diff.document.documentID {
                            data.content = diff.document.get("content") as! String
                            data.userID = diff.document.get("userID") as! String
                            data.date = diff.document.get("date") as! String
                            data.isRead = diff.document.get("isRead") as! Bool
                            
                            return data
                        }else {
                            return eachData
                        }
                    }
                }
                
                if (diff.type == .removed) {
                    var removeRowIndex = 0
                    for index in self.data.indices {
                        if self.data[index].id == diff.document.documentID {
                            removeRowIndex = index
                        }
                    }
                    self.data.remove(at: removeRowIndex)
                }
            }
        }
    }
    
    // Reference link: https://firebase.google.com/docs/firestore/manage-data/add-data
    func updateData(id: String, isRead: Bool) {
        dbCollection.document(id).updateData(["isRead":isRead]) { (err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }else {
                print("update data success")
            }
        }
    }
    
    func sendMessageTouser(datas:FirebaseData, to token: String, title: String, body: String) {
        print("sendMessageTouser()")
        var isNotRead: Int = 0
        for data in datas.data {
            if !data.isRead && title == data.userID { isNotRead += 1 }
        }
        isNotRead += 1
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "priority": "high",
                                           "notification" : ["title" : title, "body" : body,"badge" : isNotRead],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(legacyServerKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                        firebaseData.createData(sender: title,msg1: body)
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

struct ThreadDataType: Identifiable {
    var id: String
    var userID: String
    var content: String
    var date:String
    var isRead:Bool = false
}

func makeToday() -> String {
    let date = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter.string(from: date)
}

func rowTrailing(userID:String, senderName:String) -> HorizontalAlignment {
    if userID == senderName {
        return HorizontalAlignment.trailing
    }else {
        return HorizontalAlignment.leading
    }
}

let threadDataTest = [ThreadDataType(id: "id1",userID:messageSimulatorSender, content: "content1", date:makeToday())]


let ReceiverFCMToken = "f-2v3bvfhUtcoCtl4DiTZ7:APA91bEbnjBT4UlIKxdcTRjDdnuXppO5WdlNJrxHqbxCHIWbBH_8z4bgXzSISheKbD57Nyfli_S_B92O7UfCCaRzkmO-xGnoDWp_kvYQ9zASta-Ile5zOGZQD4_4CXapO0VcpqAd-IFH"

// Please change it your Firebase Legacy server key
// Firebase -> Project settings -> Cloud messaging -> Legacy server key
let legacyServerKey = "AAAAK9qGntY:APA91bFwd4XzjeD9vuXCZU7ZaZ0FRmrefXNh_NFAIB_9vQB3JtYJ5xMwN1JeR2eQW7mlGskMu3kprujjNFOEhP23aF_7DYsIg5vAooyyAwyc0cEXAOhKjJew6BuZpb1R26KxZoN7bOgm"

struct ChatScreen: View {
    var sender:String
    
    init(sender:String) {
        self.sender = sender
        self.datas.sender = sender
        UITableView.appearance().separatorColor = .clear
    }
    
    @State private var fcmTokenMessage = "fcmTokenMessage"
    @State private var instanceIDTokenMessage = "instanceIDTokenMessage"
    
    @State private var notificationContent: String = ""
    
    @ObservedObject private var datas = firebaseData
    @ObservedObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        VStack {
            ZStack{
                
                HStack{
                    Text("Поддержка")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Spacer()
                    
                }
                
                
            }
            .padding([.horizontal,.bottom])
            .padding(.top,10)
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(self.datas.data){ data in
                        HStack {
                            if data.userID == self.sender { Spacer() }
                            DataRow(data: data,senderName:self.sender)
                            if data.userID != self.sender { Spacer() }
                        }
                    }
                }
                
                HStack {
                    TextField("Add text please", text: $notificationContent).textFieldStyle(RoundedBorderTextFieldStyle()).padding(10)

                    Button(action: { self.datas.sendMessageTouser(datas: self.datas,to: ReceiverFCMToken, title: self.sender, body: self.notificationContent)
                        self.notificationContent = ""
                    }) {
                        Text("Send").font(.body)
                    }.padding(10)
                }
            }.padding()
            .padding(.bottom, keyboard.currentHeight)
            .edgesIgnoringSafeArea(.bottom)
            .animation(.easeOut(duration: 0.16))
            }
    }
    
    func checkRead() {
        print("check the read")
        UIApplication.shared.applicationIconBadgeNumber = 0
        for data in datas.data {
            if self.sender != data.userID && data.isRead == false {
                self.datas.updateData(id: data.id, isRead: true)
            }
        }
    }
}


// Keyboard Responder
final class KeyboardResponder: ObservableObject {
    private var notificationCenter: NotificationCenter
    @Published private(set) var currentHeight: CGFloat = 0

    init(center: NotificationCenter = .default) {
        notificationCenter = center
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyBoardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        notificationCenter.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardWillHide(notification: Notification) {
        currentHeight = 0
    }
}

let messageSimulatorSender = "Поддержка"
let messageDeviceSender = "Пользователь"

import SwiftUI

struct DataRow: View {
    var data: ThreadDataType
    var senderName: String
    var messageBackgroundColor: Color {
        return data.userID == senderName ? Color.orange : Color.green
    }
    var isOtherUserMessage:Bool {
        return data.userID != senderName ? true : false
    }
    var rowTrailing: HorizontalAlignment? {
        return data.userID == senderName ? .trailing: .leading
    }
    var otherUserName: String? {
        return data.userID != messageSimulatorSender ? messageDeviceSender: messageSimulatorSender
    }
    
    var body: some View {
        VStack(alignment: self.rowTrailing!) {
            if isOtherUserMessage {
                Text(otherUserName!).bold().font(.subheadline).padding(4)
            }
            HStack {
                if !isOtherUserMessage && !data.isRead{
                    Text("1").foregroundColor(Color.yellow)
                }
                
                Text(data.content)
                    .padding(8)
                    .background(messageBackgroundColor)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    .font(Font.body)
            }
            Text(data.date)
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
    }
}

struct DataRow_Previews: PreviewProvider {
    static var previews: some View {
        DataRow(data: threadDataTest[0],senderName:"senderName").previewLayout(PreviewLayout.fixed(width: 500, height: 140))
    }
}
