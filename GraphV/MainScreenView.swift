//
//  MainScreenView.swift
//  GraphV
//
//  Created by Ameya Kale on 2/19/24.
//

import SwiftUI

struct MainScreenView: View {
    
    var body: some View {
        TabView {
            GraphView()
                .tabItem {
                    Image(systemName: "circle.grid.cross")
                    Text("GraphV")
                }
                .tag(0)
            
             Text("YTView")
                .tabItem {
                    Image(systemName: "play.tv.fill")
                    Text("Videos")
                }
                .tag(1)
//
            Text("NotesView")
                .tabItem {
                    Image(systemName: "pencil.and.list.clipboard")
                    Text("Notes")
                }
                .tag(2)

             Text("QuizView")
                .tabItem {
                    Image(systemName: "questionmark.bubble")
                    Text("Quiz")
                }
                .tag(3)

             ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
                .tag(4)
        }
        
        
    }
}

//#Preview {
//    MainScreenView()
//        .environmentObject(AuthenticationViewModel())
//}
