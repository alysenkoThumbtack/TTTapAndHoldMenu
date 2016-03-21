//
//  DataController.swift
//  TTTapAndHoldMenu
//
//  Created by alysenko on 17/03/16.
//  Copyright © 2016 alysenko. All rights reserved.
//

import Foundation

enum Gender: String {
    case Male = "Male"
    case Female = "Female"
    
    static func values() -> [String] {
        return [Male.rawValue, Female.rawValue]
    }
}

enum Role: String {
    case User = "User"
    case Admin = "Admin"
    
    static func values() -> [String] {
        return [User.rawValue, Admin.rawValue]
    }
}

class User {
    var id: Int
    var name: String
    var surname: String
    var gender: Gender
    
    var role: Role
    
    static var nextId = 1
    
    init(name: String, surname: String, gender: Gender, role: Role) {
        self.name = name
        self.surname = surname
        self.gender = gender
        
        self.role = role
        
        self.id = User.nextId
        User.nextId++
    }
}

class DataController {
    var users: [User] = []
    var anotherUsers: [User] = []
    
    init() {
        restoreDefaultUsers()
    }
    
    func restoreDefaultUsers() {
        users.removeAll()
        
        let bob = User(name: "Bob", surname: "Brown", gender: .Male, role: .Admin)
        let mary = User(name: "Mary", surname: "Right", gender: .Female, role: .User)
        let gary = User(name: "Gary", surname: "Oldman", gender: .Male, role: .User)
        
        users.append(bob)
        users.append(mary)
        users.append(gary)
        
        anotherUsers.removeAll()
        
        let bilbo = User(name: "Bilbo", surname: "Baggins", gender: .Male, role: .User)
        anotherUsers.append(bilbo)
        
        for (var i = 0; i < 20; i++) {
            let gender = (i % 2 == 0) ? Gender.Male : Gender.Female
            let role = (i % 3 == 0) ? Role.Admin : Role.User
            let user = User(name: "user\(i)", surname: "\(i)", gender: gender, role: role)
            
            anotherUsers.append(user)
        }
    }
}