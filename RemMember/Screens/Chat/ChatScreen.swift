//
//  ChatScreen.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftUI
import FirebaseFirestoreSwift
import Firebase

class ChatModelTest: ObservableObject{
    
    @Published var txt = ""
    @Published var msgs = [MsgModel]()
    @AppStorage("current_user") var user = ""
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    let ref = Firestore.firestore()
    
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
        
        ref.collection("Msgs").whereField("sender", isEqualTo: userID ?? "").order(by: "timeStamp", descending: false).addSnapshotListener { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
              
            self.msgs = documents.compactMap { queryDocumentSnapshot -> MsgModel? in
                print("MSGS_DONE")
              return try? queryDocumentSnapshot.data(as: MsgModel.self)
            }
        }
    }
    func readChannelMsgs(user: String){
        
        ref.collection("Msgs\(user)").order(by: "timeStamp", descending: false).addSnapshotListener { (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
              print("No documents")
              return
            }
              
            self.msgs = documents.compactMap { queryDocumentSnapshot -> MsgModel? in
                print("MSGS_DONE")
              return try? queryDocumentSnapshot.data(as: MsgModel.self)
            }
        }
    }
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        print( String((0..<length).map{ _ in letters.randomElement()! }))
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func writeMsgToAll(text: String){
        let db = Firestore.firestore()
        let name  = UserDefaults.standard.string(forKey: "ClientName")!
//        let retrive4  = UserDefaults.standard.string(forKey: "ClientStreet")!
//        let retrive5  = UserDefaults.standard.string(forKey: "ClientApt")!
//        let retrive6  = UserDefaults.standard.string(forKey: "ClientPad")!
//        let retrive7  = UserDefaults.standard.string(forKey: "ClientFloor")!
//       let retrive8  = UserDefaults.standard.string(forKey: "ClientHouse")!
        // creating dict of adress...
        
        db.collection("Msgs").document(randomString(length: 20)).setData([
            
            "msg": text,
            "reciever": "TR2QWLiEXUPMRaj9seZhsZQo7xx1",
            "user": name,
            "timeStamp": Date(),
            "sender" : Auth.auth().currentUser!.uid
            
        ]) { (err) in
            
            if err != nil {
                
                return
            }
            print("success User add")
        }
        
    }
    func writeMsg(text: String,user: String){
        let db = Firestore.firestore()
        let name  = UserDefaults.standard.string(forKey: "ClientName")!
//        let retrive5  = UserDefaults.standard.string(forKey: "ClientApt")!
//        let retrive6  = UserDefaults.standard.string(forKey: "ClientPad")!
//        let retrive7  = UserDefaults.standard.string(forKey: "ClientFloor")!
//       let retrive8  = UserDefaults.standard.string(forKey: "ClientHouse")!
        // creating dict of adress...
        
        db.collection("Msgs\(user)").document(randomString(length: 20)).setData([
            
            "msg": text,
            "reciever": "TR2QWLiEXUPMRaj9seZhsZQo7xx1",
            "user": name,
            "timeStamp": Date(),
            "sender" : Auth.auth().currentUser!.uid
            
        ]) { (err) in
            
            if err != nil {
                
                return
            }
            print("success User add")
        }
        
    }
}


struct MsgModel: Codable,Identifiable,Hashable {
    
    @DocumentID var id : String?
    var msg : String
    var user : String
    var timeStamp: Date
    var sender: String
    var reciever: String
    
    enum CodingKeys: String,CodingKey {
        case id
        case msg
        case user
        case timeStamp
        case sender
        case reciever
    }
}


struct ChatRow: View {
    var chatData : MsgModel
    @AppStorage("current_user") var user = ""
    var body: some View {
        
        HStack(spacing: 15){
            
            // NickName View...
            
//            if chatData.user != user{
//
//                NickName(name: chatData.user)
//            }
            
            if chatData.user == user{Spacer(minLength: 0)}
            
            VStack(alignment: chatData.user == user ? .trailing : .leading, spacing: 5, content: {
                
                Text(chatData.msg)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("blue"))
                // Custom Shape...
                    .clipShape(ChatBubble(myMsg: chatData.user == user))
                
                Text(chatData.timeStamp,style: .time)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(chatData.user != user ? .leading : .trailing , 10)
            })
            
//            if chatData.user == user{
//
//                NickName(name: chatData.user)
//            }
            
            if chatData.user != user{Spacer(minLength: 0)}
        }
        .padding(.horizontal)
        // For SCroll Reader....
        .id(chatData.id)
    }
}

struct NickName : View {
    
    var name : String
    @AppStorage("current_user") var user = ""
    
    var body: some View{
        
        Text(String(name.first!))
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background((name == user ? Color.blue : Color.green).opacity(0.5))
            .clipShape(Circle())
            // COntext menu For Name Display...
            .contentShape(Circle())
            .contextMenu{
                
                Text(name)
                    .fontWeight(.bold)
            }
    }
}

struct ChatBubble: Shape {

    var myMsg : Bool
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft,.topRight,myMsg ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        
        return Path(path.cgPath)
    }
}

struct ChatScreen: View {
    @StateObject var homeData = ChatModelTest()
    @ObservedObject private var keyboard = KeyboardResponder()
    @AppStorage("current_user") var user = ""
    @State var userID = UserDefaults.standard.string(forKey: "UserID")
    @State var scrolled = false
    var body: some View {
        
        VStack(spacing: 0){
            
            ZStack{
                
                HStack{
                    VStack(alignment: .leading, spacing: 5){
                        Text("Поддержка")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        HStack {
                            Text("Онлайн")
                                .foregroundColor(.gray)
                            Circle()
                                .fill(Color.green)
                                .frame(width: 10, height: 10)
                        }
                    }
                    Spacer()
                    
                }
                
                
            }
            .padding([.horizontal,.bottom])
            .padding(.top,10)
            Spacer()
            ScrollViewReader{reader in
                
                ScrollView{
                    
                    VStack(spacing: 15){
                        
                        ForEach(homeData.msgs){msg in
                            
                           ChatRow(chatData: msg)
                            .onAppear{
                                // First Time Scroll
                                if msg.id == self.homeData.msgs.last!.id && !scrolled{
                                    
                                    reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
                                    scrolled = true
                                }
                            }
                        }
                        .onChange(of: homeData.msgs, perform: { value in
                            
                            // You can restrict only for current user scroll....
                            reader.scrollTo(homeData.msgs.last!.id,anchor: .bottom)
                        })
                    }
                    .padding(.vertical)
                }
            }
            
            HStack(spacing: 15){
                
                TextField("Ваше сообщение", text: $homeData.txt)
                    .padding(.horizontal)
                    // Fixed Height For Animation...
                    .frame(height: 45)
                    .background(Color.primary.opacity(0.06))
                    .clipShape(Capsule())
                
                if homeData.txt != ""{
                    
                    Button(action: {
                        homeData.writeMsgToAll(text: homeData.txt)
                        homeData.writeMsg(text: homeData.txt, user: userID ?? "")
                        homeData.txt = ""
                    }){
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .frame(width: 45, height: 45)
                            .background(Color("blue"))
                            .clipShape(Circle())
                    }
                }
            }
            .animation(.default)
            .padding()
        }
//        .padding()
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut(duration: 0.16))
        .onAppear(perform: {
            
            homeData.readAllMsgs()
            homeData.readChannelMsgs(user: userID ?? "")
        })
//        .ignoresSafeArea(.all, edges: .top)
    }
}

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
