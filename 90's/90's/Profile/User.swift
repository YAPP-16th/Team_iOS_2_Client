//
//  User.swift
//  90's
//
//  Created by 성다연 on 2020/04/13.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

let UserDatabase = UserModel()

class User {
    var userId : String
    var email : String
    var phone : String
    var password : String
    var name : String? {
        let nick = email.components(separatedBy: "@")
        return nick.first
    }
    var picture : UIImage? {return UIImage(named: "defaultprofile")}
    
    init(userId : String, email : String, phone : String, password : String) {
        self.userId = userId
        self.email = email
        self.phone = phone
        self.password = password
    }
}

class UserModel {
    var MemberList : [User] = []
    
    func defaultData() -> [User] {
        let person = User(userId: "1234", email: "test@gmail.com", phone: "000-0000-0000", password: "1234")
        return [person]
    }
    
    init() {
        MemberList = defaultData()
    }
}
