//
//  OriginView.swift
//  GraphV
//
//  Created by Ameya Kale on 4/29/24.
//

import SwiftUI

struct OriginView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        if(authenticationViewModel.isSignedIn){
            MainScreenView()
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.white)
        }
        else{
            SignUpView()
        }
    }
}

//#Preview {
//    OriginView()
//        .environmentObject(AuthenticationViewModel())
//}
