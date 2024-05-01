//
//  AuthenticationViewModel.swift
//  GraphV
//
//  Created by Ameya Kale on 4/29/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift

class AuthenticationViewModel: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var userID = ""
    @Published var username = ""
    @Published var email = ""
    @Published var password = ""
    @Published var userPhoto: UIImage?
    @Published var dateOfBirth = Date()
    @Published var userNotes = ""
    
    @Published var isSignedIn = false
    @Published var signInError = ""
    @Published var logInError = ""
    @Published var signOutError = ""
    @Published var updateMsg = ""
    @Published var updateSuccess = false
    
    func storeUserData(_ user: User) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "uid": user.id,
            "email": user.email,
            "username": user.username,
            "dateOfBirth": user.dateOfBirth,
            "userNotes": user.userNotes,
        ]) { error in
            if let error = error {
                print("Error storing user data: \(error.localizedDescription)")
            } else {
                print("User data stored successfully")
            }
        }
    }
    
    func signIn() async {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.signInError = "\(error.localizedDescription)"
                }
            } else {
                guard let user = Auth.auth().currentUser else { return }
            
                let userData = User(id: result?.user.uid ?? "", email: self.email, username: self.username, dateOfBirth: self.dateOfBirth, userNotes: self.userNotes)
                
                self.storeUserData(userData)
                print("Registration successful")
//                self.isSignedIn = true
            }
        }
    }
    
    func logIn () async {
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if(error != nil){
                DispatchQueue.main.async {
                    self.logInError = "\(error!.localizedDescription)"
                }
                print(self.logInError)
            }
            
            guard let user = result?.user else {
                DispatchQueue.main.async {
                    self.logInError = "Invalid Credentials"
                }
                print(self.logInError)
                return
            }
            
            let userDocumentRef = self.db.collection("users").whereField("email", isEqualTo: self.email)

            userDocumentRef.getDocuments { (document, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        self.logInError = "Error retrieving document: \(error.localizedDescription)"
                    }
                    print(self.logInError)
                    return
                }
                
                guard let documents = document?.documents else {
                    DispatchQueue.main.async {
                        self.logInError = "Document data was empty"
                    }
                    print(self.logInError)
                    return
                }
                
                if documents.isEmpty { return }
                
                let documentData = documents.first!
                
                DispatchQueue.main.async {
                    self.username = documentData["username"] as? String ?? ""
                    self.email = documentData["email"] as? String ?? ""
                    if let timestamp = documentData["dateOfBirth"] as? Timestamp {
                        self.dateOfBirth = timestamp.dateValue()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        let formattedDate = dateFormatter.string(from: self.dateOfBirth)
                        //self.dateOfBirth = Date(formattedDate)
                    }
                    else {
                        self.dateOfBirth = Date()
                    }
                    self.userNotes = documentData["userNotes"] as? String ?? ""
                }
                
//                self.isSignedIn = true
                print("login successful")
            }
        }
    }
    
    func updateUser() async {
        let newData = [
            "username": username,
            "dateOfBirth": dateOfBirth,
            "userNotes": userNotes,
        ] as [String : Any]
        
        let userQuery = self.db.collection("users").whereField("email", isEqualTo: self.email)

        userQuery.getDocuments { (querySnapshot, error) in
            if let error = error {
                DispatchQueue.main.async {
                    self.updateMsg = "Error fetching documents: \(error)"
                    self.updateSuccess = false
                }
                print("updateMsg = \(self.updateMsg)")
                return
            }

            guard let documents = querySnapshot?.documents else {
                DispatchQueue.main.async {
                    self.updateMsg = "No documents found"
                    self.updateSuccess = false
                }
                print("updateMsg = \(self.updateMsg)")
                return
            }

            for document in documents {
                let documentRef = document.reference
                documentRef.updateData(newData) { error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.updateMsg = "Error updating document: \(error)"
                            self.updateSuccess = false
                        }
                        print("updateMsg = \(self.updateMsg)")
                    } else {
                        DispatchQueue.main.async {
                            self.updateMsg = "Saved!"
                            self.updateSuccess = true
                        }
                        print("updateMsg = \(self.updateMsg)")
                    }
                }
            }
        }
    }
    
    func signOut() async {
        do {
            try Auth.auth().signOut()
            
            DispatchQueue.main.async {
                self.userID = ""
                self.username = ""
                self.email = ""
                self.password = ""
                self.dateOfBirth = Date()
                self.userNotes = ""
                
                self.isSignedIn = false
                
                self.signInError = ""
                self.logInError = ""
                self.updateMsg = ""
                self.updateSuccess = false
            }
        }
        catch let signOutError as NSError {
            DispatchQueue.main.async {
                self.signOutError = "Error signing out: \(signOutError.localizedDescription)"
            }
        }
    }
    
    func signInWithGoogle() async -> Bool {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
          fatalError("No client ID found in Firebase configuration")
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
          print("There is no root view controller!")
          return false
        }
    
        do {
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else { return false }
            let accessToken = user.accessToken
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,accessToken: accessToken.tokenString)

            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
              
            guard let user = Auth.auth().currentUser else { return false }
            
            DispatchQueue.main.async {
                self.email = user.email ?? ""
            }
            
            print(self.email)
            
            print("getting document")
            let userDocumentRef = self.db.collection("users").whereField("email", isEqualTo: self.email)
            print("got userDocumentRef")
            
            userDocumentRef.getDocuments { (document, error) in
                print("getting getDocuments")
                if let error = error {
                    self.logInError = "Error retrieving document: \(error.localizedDescription)"
                    print(self.logInError)
                    return
                }
                
                print("no error")
                
                if let documents = document?.documents, !documents.isEmpty {
                    let documentData = documents.first!
                    DispatchQueue.main.async {
                        self.username = documentData["username"] as? String ?? ""
//                        self.email = documentData["email"] as? String ?? ""
                        if let timestamp = documentData["dateOfBirth"] as? Timestamp {
                            self.dateOfBirth = timestamp.dateValue()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMMM dd, yyyy"
                            let formattedDate = dateFormatter.string(from: self.dateOfBirth)
                            //self.dateOfBirth = Date(formattedDate)
                        } else {
                            self.dateOfBirth = Date()
                        }
                        self.userNotes = documentData["userNotes"] as? String ?? ""
                    }
//                    self.logInError = "Document data was empty"
//                    print(self.logInError)
//                    return
                }
                else{
                    let userData = User(id: result.user.uid ?? "", email: self.email, username: self.username, dateOfBirth: self.dateOfBirth, userNotes: self.userNotes)
                    
                    self.storeUserData(userData)
                    print("Registration successful")
                }
                
//                if documents.isEmpty { return }
                
//                let documentData = documents.first!
                
//                self.isSignedIn = true
                print("login successful")
            }
                
                return true
          }
          catch {
            signInError = error.localizedDescription
            return false
          }
      }
}
