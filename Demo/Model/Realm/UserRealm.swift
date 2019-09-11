//
//  PostRealm.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class UserRealm: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var email: String = ""

    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    convenience init(id:Int, name: String, username:String, email:String) {
        self.init()
        setVariables(id:id, name: name, username: username, email: email)
    }
    
    convenience init(_ user: User) {
        self.init()
        setVariables(id: user.id, name:user.name, username: user.username, email: user.email)
    }
    
    private func setVariables(id:Int, name: String, username:String, email:String) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
    }
}
