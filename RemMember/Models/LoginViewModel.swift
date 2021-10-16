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
    @Published var isVerify: Bool = false
    @Published var isVerified: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
}

extension ViewModel {
    
    func sendCode() {
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        self.isLoading.toggle()
         UserDefaults.standard.setValue(phoneNumber, forKey: "Clientnumber")
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            
            self.isLoading.toggle()
            
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            
            UserDefaults.standard.set(verificationId, forKey: "verificationId")
            self.isVerify.toggle()
        }
    }
    
    func verifyCode(code: String) {
        
        self.isLoadingVerify.toggle()
        
        let verificationId = UserDefaults.standard.string(forKey: "verificationId") ?? ""
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
        
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            
            self.isLoadingVerify.toggle()
            
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }
            
            print(authResult ?? "")
            self.isVerify.toggle()
            self.isVerified.toggle()
        }
        
    }
}

