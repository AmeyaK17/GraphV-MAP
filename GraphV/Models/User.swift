//
//  User.swift
//  GraphV
//
//  Created by Ameya Kale on 4/29/24.
//

import Foundation
import UIKit

class User: Identifiable {
    var id: String
    var username: String
    var email: String
    var dateOfBirth: Date
    var userNotes: String
    
    init(id: String, email: String, username: String, dateOfBirth: Date, userNotes: String) {
        self.id = id
        self.username = username
        self.email = email
        self.dateOfBirth = dateOfBirth
        self.userNotes = userNotes
    }
}
