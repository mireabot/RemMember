//
//  SearchAddressView.swift
//  RemMember
//
//  Created by Максим Данько on 18.11.2021.
//

import SwiftUI
import iTextField

struct SearchAddressView: View {
    
    @Binding var text: String
    @Binding var isEditing: Bool
        
    @StateObject private var viewModel = SearchAddressViewModel()
       
    var body: some View {
        VStack {
            SearchBar(text: $viewModel.text, isEditing: $isEditing)
                .padding(.horizontal, 16)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(viewModel.items, id: \.self) { item in
                        SearchAddressRow(item: item).onTapGesture {
                            text = "\(item.title) \(item.subtitle)"
                            isEditing = false
                        }
                    }
                }
            }.padding(.top, 16)
        }
    }
    
}

struct SearchBar: View {
    
    @Binding var text: String
    @Binding var isEditing: Bool
    
    var body: some View {
        iTextField("Укажите свой адрес", text: $text, isEditing: $isEditing)
            .returnKeyType(.done)
            .foregroundColor(.black)
            .padding(.vertical, 12)
            .padding(.horizontal, 12)
            .background(Color.black.opacity(0.06))
            .frame(height: 48)
            .cornerRadius(10)
    }
}

struct SearchAddressRow: View {
    
    let item: LocalSearchCompleterItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .fontWeight(.regular)
                .foregroundColor(.black)
            Text(item.subtitle)
                .fontWeight(.light)
                .foregroundColor(.black)
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
}
