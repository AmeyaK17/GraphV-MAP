//
//  SignInView.swift
//  GraphV
//
//  Created by Ameya Kale on 4/29/24.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @State var showSheet = false
    
    var body: some View {
        ScrollView{
            VStack{
                Text("Welcome to GraphV!")
                    .font(.largeTitle)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                    .padding()
                
                Spacer()
                
                Image(systemName: "person.fill.badge.plus")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
//                    .shadow(color: .gray,radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                Text("Sign Up!")
                    .font(.largeTitle)
                    .foregroundStyle(.gray)
                
                TextField("User Name", text: $authenticationViewModel.username)
                    .frame(width: 300, height: 50)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.blue, lineWidth: 2)
                    )
                    .padding()
                
                TextField("Email", text: $authenticationViewModel.email)
                    .frame(width: 300, height: 50)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.blue, lineWidth: 2)
                    )
                    .padding()
                
                SecureField("Password", text: $authenticationViewModel.password)
                    .frame(width: 300, height: 50)
                    .padding(.horizontal, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.blue, lineWidth: 2)
                    )
                    .padding()
                
                
                Button(
                    action: {
                        Task{
                            await authenticationViewModel.signIn()
                            authenticationViewModel.isSignedIn = true
                        }
                    } ,
                    label: {
                        Text("Sign Up")
                            .fontWeight(.semibold)
                    })
                .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                .background(.green)
                .foregroundColor(.black)
                .cornerRadius(25)
                .padding()
                
                Button(
                    action: {
                        showSheet = true
                    } ,
                    label: {
                        HStack{
                            Text("Already have an account?")
                                .foregroundStyle(.white)
                            Text("Login")
                                .underline()
                                .foregroundStyle(.blue)
                        }
                        
                    })
                .foregroundColor(.blue)
                
                if(!authenticationViewModel.signInError.isEmpty){
                    HStack(alignment: .center){
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text(authenticationViewModel.signInError)
                    }
                    .foregroundStyle(.orange)
                    .padding()
                }
                
            }
        }
        .sheet(isPresented: $showSheet, content: {
            ScrollView{
                VStack{
                    HStack{
                        Button(action: {
                            showSheet = false
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.blue)
                                .font(.title)
                        }
                        .padding()
                        
                        Spacer()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "person.badge.key.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
//                        .shadow(color: .gray,radius: 5)
                    
                    Text("Log In!")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                    
                    TextField("Email", text: $authenticationViewModel.email)
                        .frame(width: 300, height: 50)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .padding()
                    
                    SecureField("Password", text: $authenticationViewModel.password)
                        .frame(width: 300, height: 50)
                        .padding(.horizontal, 20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(.blue, lineWidth: 2)
                        )
                        .padding()
                    
                    Button(
                        action: {
                            Task{
                                await authenticationViewModel.logIn()
                                authenticationViewModel.isSignedIn = true
                            }
                        } ,
                        label: {
                            Text("Log In")
                                .fontWeight(.semibold)
                        })
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 50)
                    .background(.green)
                    .foregroundColor(.black)
                    .cornerRadius(25)
                    .padding()
                    
                    if(!authenticationViewModel.logInError.isEmpty){
                        HStack(alignment: .center){
                            Image(systemName: "exclamationmark.triangle.fill")
                            Text(authenticationViewModel.logInError)
                        }
                        .foregroundStyle(.orange)
                        .padding()
                    }
                    
                    
                    Spacer()
                }
            }
        })
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}
