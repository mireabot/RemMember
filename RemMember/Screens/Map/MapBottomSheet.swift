//
//  MapBottomSheet.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import iTextField

struct MapBottomSheet: View {
  
    @Binding var isFullPresented: Bool
    @Binding var comments: String
    @Binding var searchedAddress: String
    
    let animation: Animation
    let onPress: () -> Void
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.white)
            ZStack {
                VStack(alignment: .leading) {
                    Group {
                        Text("Адрес")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        MapBottomInputView(title: $searchedAddress, placeholder: "Укажите свой адрес").onTapGesture {
                            withAnimation {
                                isFullPresented.toggle()
                            }
                        }
                        Text("Комментарий")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.black)
                        iTextField("Квартира, этаж, подъезд", text: $comments)
                            .returnKeyType(.done)
                            .foregroundColor(Color.black)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 12)
                            .background(Color.black.opacity(0.06))
                            .frame(height: 48)
                            .cornerRadius(10)
                        MapBottomButtonView(didPress: {
                            onPress()
                        }).padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .opacity(isFullPresented ? 0 : 1)
                    .animation(animation, value: isFullPresented)
                }
                
                SearchAddressView(text: $searchedAddress, isEditing: $isFullPresented)
                    .padding(.top, 16)
                    .opacity(isFullPresented ? 1 : 0)
                    .animation(animation, value: isFullPresented)
            }
        }
    }
}
