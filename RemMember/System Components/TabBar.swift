//
//  TabBar.swift
//  RemMember
//
//  Created by Mikhail Kolkov on 16.10.2021.
//

import Foundation
import SwiftUI


struct CustomTabView : View {

      @State var selectedTab = "Главная"
        @State var showChat = false
    @AppStorage("log_Status") var type = ""
      var edges = UIApplication.shared.windows.first?.safeAreaInsets
      @Namespace var animation

      var body: some View{

          VStack(spacing: 0){

              GeometryReader{_ in

                  ZStack{
                      
                      Home1()
                        .opacity(selectedTab == "Главная" ? 1 : 0)
                      ProfileScreen()
                        .opacity(selectedTab == "Профиль" ? 1 : 0)

                  }
              }

              HStack(spacing: 0){
                  
                  ForEach(tabs,id: \.self){tab in
                      
                      TabButton(title: tab, selectedTab: $selectedTab,animation: animation)
                      
                      if tab != tabs.last{
                          Spacer(minLength: 0)
                      }
                  }
              }
              .padding(.horizontal,30)
              // for iphone like 8 and SE
              .padding(.bottom,edges!.bottom == 0 ? 15 : edges!.bottom)
              .background(Color.white)
          }
          .ignoresSafeArea(.all, edges: .bottom)
      }
  }
var tabs = ["Главная","Профиль","Чат"]

struct TabButton : View {
    
    var title : String
    @Binding var selectedTab : String
    var animation : Namespace.ID
    @State var userData = OrderTestModel()
    var body: some View{
        
        Button(action: {
            withAnimation{selectedTab = title}
        }) {
            
            VStack(spacing: 6){
                
                // Top Indicator....
                
                // Custom Shape...
                
                // Slide in and out animation...
                
                ZStack{
                    
                    CustomShape1()
                        .fill(Color.clear)
                        .frame(width: 45, height: 6)
                    
                    if selectedTab == title{
                        
                        CustomShape1()
                            .fill(Color("blue"))
                            .frame(width: 45, height: 6)
                            .matchedGeometryEffect(id: "Tab_Change", in: animation)
                    }
                }
                .padding(.bottom,10)
                
                Image(title)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(selectedTab == title ? Color("blue") : Color.black.opacity(0.2))
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.black.opacity(selectedTab == title ? 0.6 : 0.2))
            }
        }
        .onAppear{
            userData.fetchAndMap()
        }
    }
}

// Custom Shape..

struct CustomShape1: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}








