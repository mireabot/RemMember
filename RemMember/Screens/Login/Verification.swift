//
//  Verification.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI
import SwiftUIX

struct Verification: View {
    
    @ObservedObject var viewModel: ViewModel
    
    @State var sms_code = ""
    
    @State var isLoading: Bool = false
    
    var body: some View {
        VStack {
            Image("img2")
                .padding()
            
            Text("Подтверждение")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Мы отправили код на номер \(Text(viewModel.phoneNumber).fontWeight(.bold).foregroundColor(.black))")
                .font(.callout)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack {
                
                TextField("Код", text: $sms_code)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.2)
                    .keyboardType(.phonePad)
                
                Divider()
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 1)
                    .padding(.bottom)
                
            }.padding()
            
            Button(action: {
                viewModel.verifyCode(code: sms_code,pin: viewModel.code)
                
            }, label: {
                Text("Далее")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 50,height: 56)
                    .background(Color("blue"))
                    .cornerRadius(12)
                    .opacity(viewModel.isLoadingVerify ? 0.2 : 1)
                    .overlay(
                        viewModel.isLoadingVerify ? ProgressView() : nil
                    )
            })
            .padding()
            .disabled(viewModel.isLoadingVerify)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 1.2)
        .padding()
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 25, x: 1, y: 1)
        .preferredColorScheme(.light)
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

