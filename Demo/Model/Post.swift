//
//  Post.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

struct Post: Hashable, Codable {
    var id: Int
    var userId: Int
    var title: String
    var body: String
    
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    private enum CodingKeys: String, CodingKey {
       case id
       case userId
       case title
       case body
   }
    
    init(postRealm: PostRealm) {
        self.id = postRealm.id
        self.userId = postRealm.userId
        self.title = postRealm.title
        self.body = postRealm.body
    }
}

struct PostViewModel: Equatable {

    static func == (lhs: PostViewModel, rhs: PostViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id: Int
    var author: String
    var title: String
    var body: String
    
    init(post: Post) {
        self.id = post.id
        self.author = "aaaa"
        self.title = post.title
        self.body = post.body
    }
}


