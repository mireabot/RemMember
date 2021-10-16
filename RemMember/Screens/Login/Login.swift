//
//  Login.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import SwiftUI
import SwiftUIX

struct Login: View {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Image("logo")
                
                Text("Введите номер телефона")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(20)
                
                Text("Он нужен нам для оперативной связи с Вами")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                
                TextField("+7", text: $viewModel.phoneNumber)
                    .font(.title2)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 60)
                    .keyboardType(.phonePad)
                
                Divider()
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, maxHeight: 1)
                    .padding(.bottom)
                
                Button(action: {
                    withAnimation {
                        viewModel.sendCode()
                    }
                }, label: {
                    Text("Отправить код")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(Color("blue"))
                        .cornerRadius(6)
                        .shadow(color: Color("blue").opacity(0.8), radius: 6, x: 1, y: 1)
                        
                }).padding()
            }
            .blur(radius: viewModel.isLoading || viewModel.isVerify || viewModel.isVerified ? 20 : 0)
            
            if viewModel.isLoading {
                Loading()
            }
            
            Verification(viewModel: viewModel)
                .opacity(viewModel.isVerify ? 1 : 0)
                .scaleEffect(CGSize(width: viewModel.isVerify ? 1 : 0, height: viewModel.isVerify ? 1 : 0), anchor: .center)
                .animation(.interpolatingSpring(stiffness: 200, damping: 10, initialVelocity: 5))
            
            Done()
                .opacity(viewModel.isVerified ? 1 : 0)
                .scaleEffect(CGSize(width: viewModel.isVerified ? 1 : 0, height: viewModel.isVerified ? 1 : 0), anchor: .center)
                .animation(.interpolatingSpring(stiffness: 200, damping: 10, initialVelocity: 5))
        }
        .onTapGesture {
            hideKeyboard()
        }
        .alert(isPresented: $viewModel.isError, content: {
            Alert(title: Text("Error"), message: Text(viewModel.errorMsg))
        })
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

struct Loading: View {
    var body: some View {
        ProgressView()
    }
}


struct Done: View {
    
    @AppStorage("isLoggedIn") var isLogin: Bool = false
    
    var body: some View {
        VStack {
            Image("img3")
            
            Text("Номер подтвержден!")
                .font(.title2)
                .fontWeight(.bold)
            
            Button(action: {
                
                isLogin = true
                
            }, label: {
                Text("Далее")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.3, maxHeight: 50)
                    .background(Color("blue"))
                    .cornerRadius(6)
                    .shadow(color: Color("blue").opacity(0.8), radius: 6, x: 1, y: 1)
            }).padding()
        }.frame(maxWidth: UIScreen.main.bounds.width / 1.2)
        .padding()
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 25)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 25, x: 1, y: 1)
    }
}

struct Done_Previews: PreviewProvider {
    static var previews: some View {
        Done()
    }
}

