//
//  Version.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI
import Firebase

struct Version : View {
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .frame(width: 295, height: 94)
            Spacer()
            VStack(spacing: 10){
                Text("Версия 1.0 (15)")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
                Text("Все права защищены @RemMember")
                    .foregroundColor(.black)
                    .fontWeight(.semibold)
            }
        }
    }
}


