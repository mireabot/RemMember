//
//  HomeViewModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI
import CoreLocation
import Firebase

// Fetching User Location....
class HomeViewModel: NSObject,ObservableObject,CLLocationManagerDelegate{
    
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
//    let db = Firestore.firestore()
    
    // Location Details....
    @Published var userLocation : CLLocation!
    @Published var userAddress = ""
    @Published var noLocation = false
    @Published var permissionDenied = false
    
    // Menu...
    @Published var showMenu = false
    
    // ItemData...
//    @Published var orders: [Order] = []
    @Published var user_phones : [UserPhone] = []
    // Timed Event
    @Published var events = [Event]()
    
    @Published var items: [iPhones] = []
    @Published var filtered: [iPhones] = []
    
    @Published var accessories: [Accessories] = []
    @Published var filtered_accessories: [Accessories] = []
    
    // Cart Data...
    @State var bd = UserDefaults.standard.string(forKey: "ClientDevice")
    @State var bd_acc = "iPhone_Acc"
    @AppStorage("log_Status") var status = false
    @State var name = UserDefaults.standard.string(forKey: "ClientName")
    @State var phone_number = UserDefaults.standard.string(forKey: "Clientnumber")
    @State var device = UserDefaults.standard.string(forKey: "ClientDevice")
    @Published var cartItems : [Cart] = []
    @Published var cartItemsAcc : [CartAcc] = []
    @Published var ordered = false
    private var db = Firestore.firestore()
    @State var order_number = 0
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        // checking Location Access....
        
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("authorized")
            self.noLocation = false
            manager.requestLocation()
        case .denied:
            print("denied")
            self.noLocation = true
            self.permissionDenied.toggle()
        default:
            print("unknown")
            self.noLocation = false
            // Direct Call
            locationManager.requestWhenInUseAuthorization()
        // Modifying Info.plist...
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // reading User Location And Extracting Details....
        
        self.userLocation = locations.last
        self.extractLocation()
        // after Extracting Location Logging In....
//        self.login()
//        self.fetchData()
    }
    
    func extractLocation(){
        
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { (res, err) in
            
            guard let safeData = res else{return}
            
            var address = ""
            
            // getting area and locatlity name....
            
            address += safeData.first?.name ?? ""
//            address += ", "
//            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
            print(self.userLocation.coordinate.latitude)
            print(self.userLocation.coordinate.longitude)
        }
    }
    
    // anynomus login For Reading Database....
    
    func login(){
        
        Auth.auth().signInAnonymously { (res, err) in
            
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            
            print("Success = \(res!.user.uid)")
            
            // After Logging in Fetching Data
            UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "UserID")
            UserDefaults.standard.synchronize()
        }
    }
    
    // Fetching Items Data....
    
    func fetchData(){
        
        let db = Firestore.firestore()
        
        db.collection(bd ?? "iPhone 12 Mini").whereField("item_type", isNotEqualTo: "Услуга").addSnapshotListener { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.items = itemData.documents.compactMap({ (doc) -> iPhones? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let time = doc.get("item_time") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                let plus_time = doc.get("item_plus_time") as! String
                let type = doc.get("item_type") as! String
                
                print(doc.data())
                
                return iPhones(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_time: time,item_plus_time: plus_time,item_type: type)
            })
            
            self.filtered = self.items
        }
    }
    
    func fetchAdds(){
        
        let db = Firestore.firestore()
        
        db.collection(bd ?? "iPhone 12 Mini").whereField("item_type", isEqualTo: "Услуга").addSnapshotListener { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.items = itemData.documents.compactMap({ (doc) -> iPhones? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let time = doc.get("item_time") as! String
                let image = doc.get("item_image") as! String
                let details = doc.get("item_details") as! String
                let plus_time = doc.get("item_plus_time") as! String
                let type = doc.get("item_type") as! String
                
                return iPhones(id: id, item_name: name, item_cost: cost, item_details: details, item_image: image, item_time: time,item_plus_time: plus_time,item_type: type)
            })
            
            self.filtered = self.items
        }
    }
    func fetchDataEvents() {
        
      db.collection("Time_Events").addSnapshotListener { (querySnapshot, error) in
        guard let documents = querySnapshot?.documents else {
          print("No documents")
          return
        }
          
        self.events = documents.compactMap { queryDocumentSnapshot -> Event? in
            print("Users_DONE")
          return try? queryDocumentSnapshot.data(as: Event.self)
        }
      }
    }
    func fetchDataAccessories(){
        
        let db = Firestore.firestore()
        
        db.collection(bd_acc).addSnapshotListener { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.accessories = itemData.documents.compactMap({ (doc) -> Accessories? in
                
                let id = doc.documentID
                let name = doc.get("item_name") as! String
                let cost = doc.get("item_cost") as! NSNumber
                let image = doc.get("item_image") as! String
                let body = doc.get("item_body") as! String
                
                print(doc.data())
                
                return Accessories(id: id, item_name: name, item_image: image, item_cost: cost,item_body: body)
            })
            
            self.filtered_accessories = self.accessories
        }
    }
    func cancelOrder(name: String){
        
        let ref = Firestore.firestore()
        
        ref.collection("Orders").whereField("client_ID", isEqualTo: name).getDocuments(){ (q, err) in
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
                document?.reference.updateData(["status" : "Отменен"])
                document?.reference.updateData(["active" : false])
            }
        }
    }
    
    func UpdateorderStatusHistory(user_id: String, date: Date,number: Int){
        
        let ref = Firestore.firestore()
        
        ref.collection("Orders_History_\(user_id)").whereField("order_number", isEqualTo: number).getDocuments(){ (q, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
          /*  else if q!.documents.count != 1{
                print(err!.localizedDescription)
                return
            } */
            else {
                let document = q!.documents.first
                document?.reference.updateData(["status" : "Отменен"])
                document?.reference.updateData(["date" : date])
            }
        }
    }
    
    func addToCart(item: iPhones){
        
        // checking it is added...
        
        self.items[getIndex(item: item, isCartIndex: false)].isAdded = !item.isAdded
        // updating filtered array also for search bar results...
        
        let filterIndex = self.filtered.firstIndex { (item1) -> Bool in
            return item.id == item1.id
        } ?? 0
        //
        self.filtered[filterIndex].isAdded = !item.isAdded
        
        if item.isAdded{
            
            // removing from list...
            
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        // else adding...
        
        self.cartItems.append(Cart(item: item, quantity: 1))
        
    }
    
    func getIndex(item: iPhones,isCartIndex: Bool)->Int{
        
        let index = self.items.firstIndex { (item1) -> Bool in
            
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { (item1) -> Bool in
            
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    
    func calculateTotalPrice()->String{
        
        var price : Float = 0
        
        cartItems.forEach { (item) in
            price +=  Float(truncating: item.item.item_cost)
        }
        cartItemsAcc.forEach { (item) in
            price +=  Float(truncating: item.accessori.item_cost)
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float)->String{
        
        let format = NumberFormatter()
        format.numberStyle = .none
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    // writing Order Data into FIrestore...
    
    func createOrder(type: String, location: String,number: Int){
        
        
        let db = Firestore.firestore()
        
        // creating dict of food details...
        
        var details : [[String: Any]] = []
        
        cartItems.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.item.item_name,
                "item_cost": cart.item.item_cost
            ])
        }
        
        cartItemsAcc.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.accessori.item_name,
                "item_cost": cart.accessori.item_cost
            ])
        }
        
        let retrive1  = UserDefaults.standard.string(forKey: "ClientStreet")!
        let retrive2  = UserDefaults.standard.string(forKey: "ClientComment")!
//        let retrive6  = UserDefaults.standard.string(forKey: "UserID")!
        
        ordered = true
        
        db.collection("Orders").document(Auth.auth().currentUser!.uid).setData([
            
            "order": details,
            "client_name": name ?? "",
            "order_master": "",
            "master_phone": "",
            "client_adress": "\(retrive1)  \n\(retrive2)",
            "client_phone": phone_number ?? "",
            "status": "Заказ оформлен",
            "client_device" : device ?? "",
            "total_cost": calculateTotalPrice(),
            "order_number" : number,
            "payment_type": type,
            "repair_location": location,
            "active": true,
            "client_ID" : Auth.auth().currentUser!.uid,
            "date": Date()
            
        ]) { (err) in
            
            if err != nil{
                self.ordered = false
                return
            }
            print("success")
        }
        
        db.collection("Orders_History_\(Auth.auth().currentUser!.uid)").document(randomString(length: 20)).setData([
            
            "order": details,
            "client_adress": "\(retrive1)  \n\(retrive2)",
            "status": "Заказ оформлен",
            "total_cost": calculateTotalPrice(),
            "order_number" : number,
            "client_ID" : Auth.auth().currentUser!.uid,
            "date": Date()
            
        ]) { (err) in
            
            if err != nil{
                self.ordered = false
                return
            }
            print("success")
        }
        
        cartItems.removeAll()
        cartItemsAcc.removeAll()
//        order_number = 0
    }
    func createOrderHistory(){
        
        let db = Firestore.firestore()
        
        // creating dict of food details...
        
        
        var details : [[String: Any]] = []
        
        cartItems.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.item.item_name,
                "item_cost": cart.item.item_cost
            ])
        }
        
        cartItemsAcc.forEach { (cart) in
            
            details.append([
                
                "item_name": cart.accessori.item_name,
                "item_cost": cart.accessori.item_cost
            ])
        }
        
        let retrive1  = UserDefaults.standard.string(forKey: "ClientStreet")!
        let retrive2  = UserDefaults.standard.string(forKey: "ClientComment")!
//        let retrive6  = UserDefaults.standard.string(forKey: "UserID")!
        
        ordered = true
        
        db.collection("Orders_History").document(randomString(length: 20)).setData([
            
            "order": details,
            "client_adress": "\(retrive1)  \n\(retrive2)",
            "status": "Заказ оформлен",
            "total_cost": calculateTotalPrice(),
            "order_number" : order_number,
            "client_ID" : Auth.auth().currentUser!.uid,
            "date": Date()
            
        ]) { (err) in
            
            if err != nil{
                self.ordered = false
                return
            }
            print("success")
        }
        
        cartItems.removeAll()
        cartItemsAcc.removeAll()
        order_number = 0
    }
    
    
    func addToCartTest(item: Accessories){
        
        // checking it is added...
        
        self.accessories[getIndexTest(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        if item.isAdded{
            
            // removing from list...
            
            self.cartItemsAcc.remove(at: getIndexTest(item: item, isCartIndex: true))
            return
        }
        // else adding...
        print("Added")
        self.cartItemsAcc.append(CartAcc(accessori: item))
        
    }
    
    func addToCartTest1(item: Accessories){
        
        // checking it is added...
        
        self.accessories[getIndexTest(item: item, isCartIndex: false)].isAdded = !item.isAdded
        
        if item.isAdded{
            
            // removing from list...
            
            self.cartItemsAcc.remove(at: getIndexTest(item: item, isCartIndex: true))
            return
        }
        // else adding...
        print("Added")
        self.cartItemsAcc.append(CartAcc(accessori: item))
        
    }
    
    func getIndexTest(item: Accessories,isCartIndex: Bool)->Int{
        
        let index = self.accessories.firstIndex { (item1) -> Bool in
            
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItemsAcc.firstIndex { (item1) -> Bool in
            
            return item.id == item1.accessori.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    
    func SetOrdersStats(count: Int,oldCount: Int){
        
        let ref = Firestore.firestore()
        
        ref.collection("Stats").getDocuments(){ (q, err) in
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
                document?.reference.updateData(["orders" : oldCount + count])
            }
        }
    }
    func SetAmountStats(count: Int,oldCount: Int){
        
        let ref = Firestore.firestore()
        
        ref.collection("Stats").getDocuments(){ (q, err) in
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
                document?.reference.updateData(["amount" : oldCount + count])
            }
        }
    }
    func fetchClientPhones(client: String){
        
        let db = Firestore.firestore()
        
        db.collection("Client_phones").whereField("client_id", isEqualTo: client).addSnapshotListener { (snap, err) in
            
            guard let itemData = snap else{return}
            
            self.user_phones = itemData.documents.compactMap({ (doc) -> UserPhone? in
                
                let id = doc.documentID
                let client_id = doc.get("client_id") as! String
                let name = doc.get("client_phone") as! String
                
                return UserPhone(id: id, phone_name: name, client_id: client_id)
            })
        }
    }
    
    func addPhone(phone: String){
        
        let db = Firestore.firestore()
        
        // add new client adress
        
        db.collection("Client_phones").document(randomString(length: 20)).setData([
            
            "client_id": Auth.auth().currentUser!.uid,
            "client_phone": phone
            
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
    
    func OrderNumber(length: Int) -> Int {
        let letters = "0123456789"
        print(String((0..<length).map{ _ in letters.randomElement()! }))
        order_number = Int(String((0..<length).map{ _ in letters.randomElement()! })) ?? 0
        return Int(String((0..<length).map{ _ in letters.randomElement()! })) ?? 0
    }
}

