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

class CommentRealm: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var body: String = ""

    override static func primaryKey() -> String {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["id"]
    }
    
    convenience init(id:Int, postId: Int, name:String, email: String, body:String) {
        self.init()
        setVariables(id:id, postId: postId, name: name, email: email, body: body)
    }
    
    convenience init(_ comment: Comment) {
        self.init()
        setVariables(id: comment.id, postId: comment.postId, name: comment.name, email: comment.email, body: comment.body)
    }
    
    private func setVariables(id:Int, postId: Int, name:String, email: String, body:String) {
        self.id = id
        self.postId = postId
        self.name = name
        self.email = email
        self.body = body
    }
}
