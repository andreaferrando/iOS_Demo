//
//  Post.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

struct Comment: Equatable, Codable {
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var postId: Int
    var name: String
    var email: String
    var body: String
    
    init(id: Int, postId:Int, name: String, email: String, body: String) {
        self.id = id
        self.postId = postId
        self.name = name
        self.body = body
        self.email = email
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case postId
        case name
        case email
        case body
    }
    
    init(commentRealm: CommentRealm) {
        self.id = commentRealm.id
        self.postId = commentRealm.postId
        self.name = commentRealm.name
        self.body = commentRealm.body
        self.email = commentRealm.email
    }
}

struct CommentViewModel {
    var id: Int
    var title: String
    var author: String
    var body: String
    
    init(comment: Comment) {
        self.id = comment.id
        self.title = comment.name
        self.author = comment.email
        self.body = comment.body
    }
}


