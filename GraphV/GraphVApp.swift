//
//  GraphVApp.swift
//  GraphV
//
//  Created by Ameya Kale on 2/9/24.
//

import SwiftUI
import Firebase

@main
struct GraphVApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            OriginView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
