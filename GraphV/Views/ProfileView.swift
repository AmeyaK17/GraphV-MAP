//
//  ProfileView.swift
//  GraphV
//
//  Created by Ameya Kale on 4/29/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Hello, \(authenticationViewModel.username)!")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                
                
                Image(systemName: "photo.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                
                HStack{
                    Text("Full Name")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: .leading)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                    
                    TextField("User Name", text: $authenticationViewModel.username)
                        .frame(width: 200, height: 50)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                
                HStack{
                    Text("Email")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: .leading)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                    
                    Text(authenticationViewModel.email)
                        .frame(width: 240, height: 50)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.gray, lineWidth: 2)
                        )
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                
                HStack{
                    Text("DoB")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: .leading)
                        .padding(.leading, 10)
                        .foregroundColor(.white)
                    
                    DatePicker("", selection: $authenticationViewModel.dateOfBirth, displayedComponents: .date)
                        .datePickerStyle(CompactDatePickerStyle())
                        .labelsHidden()
                        .frame(width: 240, height: 50, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                
                HStack{
                    HStack{
                        Image(systemName: "heart.fill")
                            .foregroundColor(.blue)
                        Text("Genre")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white)
                    }
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50, alignment: .leading)
                    .padding(.leading, 10)
                    
                    TextField("Notes", text: $authenticationViewModel.userNotes)
                        .frame(width: 200, height: 50)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .padding(.trailing, 10)
                }
                
                Spacer()
                
                Button(
                    action: {
                        Task {
                            await authenticationViewModel.updateUser()
                        }
                    }, label: {
                        Text("Save!")
                            .fontWeight(.semibold)
                    }
                )
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                .background(.green)
                .foregroundColor(.black)
                .cornerRadius(25)
                .padding()
                
                Button(
                    action: {
                        Task {
                            await authenticationViewModel.signOut()
                            authenticationViewModel.isSignedIn = false
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "power.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding()
                            
                            Text("Log Out")
                                .fontWeight(.bold)
                        }
                        
                    }
                )
                .foregroundColor(.red)
                .padding()
                
                if(!authenticationViewModel.signOutError.isEmpty){
                    HStack{
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(authenticationViewModel.signOutError)
                    }
                    .foregroundStyle(.orange)
                    .padding()
                }
//                Spacer()
            }
        }

    }
}

//#Preview {
//    ProfileView()
//        .environmentObject(AuthenticationViewModel())
//}
