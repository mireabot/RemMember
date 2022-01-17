//
//  LoginViewModel.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import Firebase
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isLoadingVerify: Bool = false

    @Published var phoneNumber: String = "+7"
    @Published var code: String = ""
    @Published var isVerify: Bool = false
    @Published var isVerified: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
}

extension ViewModel {
    
    func sendCode() {
        
//        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        self.isLoading.toggle()
         UserDefaults.standard.setValue(phoneNumber, forKey: "Clientnumber")
            self.isVerify.toggle()
        }
    
    func verifyCode(code: String,pin: String) {
        
        self.isLoadingVerify.toggle()
        
        if pin == code {
            Auth.auth().createUser(withEmail: randomEmail(length: 5), password: randomPassword(length: 10)) { (authResult, error) in
                
                self.isLoadingVerify.toggle()
                
                if error != nil {
                    self.isError.toggle()
                    self.errorMsg = error?.localizedDescription ?? ""
                    return
                }
                
                print(authResult ?? "")
                UserDefaults.standard.setValue(Auth.auth().currentUser!.uid, forKey: "UserID")
                UserDefaults.standard.synchronize()
                self.isVerify.toggle()
                self.isVerified.toggle()
            }
        }
    }
    
    func randomEmail(length: Int) -> String {
        let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789"
        print( String((0..<length).map{ _ in letters.randomElement()! }) + String("@mail.ru"))
        
                    return String((0..<length).map{ _ in letters.randomElement()! } + String("@mail.ru"))
    }
    func randomPassword(length: Int) -> String {
        let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM0123456789"
        print( String((0..<length).map{ _ in letters.randomElement()! }))
        
                    return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

