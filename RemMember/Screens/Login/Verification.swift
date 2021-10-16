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
    
    @State var countPin = 6
    @State var currentFocus = 0
    
    @State var pin1 = ""
    @State var pin2 = ""
    @State var pin3 = ""
    @State var pin4 = ""
    @State var pin5 = ""
    @State var pin6 = ""
    
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
            
            HStack {
                
                CocoaTextField("-", text: $pin1)
                    .isFirstResponder(currentFocus == 0)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin1, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 0
                    }
                
                CocoaTextField("-", text: $pin2)
                    .isFirstResponder(currentFocus == 1)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin2, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 1
                    }
                
                CocoaTextField("-", text: $pin3)
                    .isFirstResponder(currentFocus == 2)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin3, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 2
                    }
                
                CocoaTextField("-", text: $pin4)
                    .isFirstResponder(currentFocus == 3)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin4, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 3
                    }
                
                CocoaTextField("-", text: $pin5)
                    .isFirstResponder(currentFocus == 4)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin5, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 4
                    }
                
                CocoaTextField("-", text: $pin6)
                    .isFirstResponder(currentFocus == 5)
                    .keyboardType(.numberPad)
                    .font(.system(size: 18, weight: .bold))
                    .lineLimit(1)
                    .frame(maxWidth: 50, maxHeight: 50, alignment: .center)
                    .multilineTextAlignment(.center)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color.gray.opacity(0.1), lineWidth: 2, antialiased: true)
                    )
                    .onChange(of: pin6, perform: { value in
                        if value.count > 0 {
                            currentFocus += 1
                        }
                    })
                    .onTapGesture {
                        currentFocus = 5
                    }
                
            }.padding()
            
//            HStack {
//                Text("Don't receive the OTP Code?")
//                    .font(.callout)
//                    .foregroundColor(.gray)
//
//                Button(action: {
//                    viewModel.sendCode()
//                }, label: {
//                    Text("Resend OTP")
//                        .font(.callout)
//                        .fontWeight(.bold)
//                        .foregroundColor(.orange)
//                })
//            }
            
            Button(action: {
                
                let code = pin1+pin2+pin3+pin4+pin5+pin6
                viewModel.verifyCode(code: code)
                
            }, label: {
                Text("Далее")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.3, maxHeight: 50)
                    .background(Color("blue"))
                    .cornerRadius(6)
                    .shadow(color: Color("blue").opacity(0.8), radius: 6, x: 1, y: 1)
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
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

