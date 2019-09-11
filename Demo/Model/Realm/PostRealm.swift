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

class PostRealm: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""

    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    convenience init(id:Int, userId: Int, title:String, body:String) {
        self.init()
        setVariables(id:id, userId: userId, title: title, body: body)
    }
    
    convenience init(_ post: Post) {
        self.init()
        setVariables(id: post.id, userId:post.userId, title: post.title, body: post.body)
    }
    
    private func setVariables(id:Int, userId: Int, title:String, body:String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
}
