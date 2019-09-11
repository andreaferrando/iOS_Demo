//
//  DetailsDataManager.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class DetailsLocalDataManager: DataManagerRealm, DetailsInteractorToLocalDataManagerProtocol {
  
    weak var interactor: DetailsLocalDataManagerToInteractorProtocol?
  
    func fetchPost(_ postId: Int) -> Post? {
        if let post = realm.objects(PostRealm.self).filter("id == %@", postId).first {
            return Post(postRealm: post)
        }
        return nil
    }
    
    func fetchUser(_ userId: Int) -> User? {
        if let user = realm.objects(UserRealm.self).filter("id == %@", userId).first {
            return User(userRealm: user)
        }
        return nil
    }
    
    func fetchComments(of postId: Int) -> [Comment]? {
        let realmComments = Array(realm.objects(CommentRealm.self).filter("postId == %@", postId))
        return realmComments.map{Comment(commentRealm:$0)}
    }
    
    func writeComments(_ comments: [Comment]) {
        let realmComments = comments.compactMap{CommentRealm($0)}
        self.write(realmComments, update: true)
    }
    
    func writeUser(_ user: User) {
        let realmUser = UserRealm(user)
        self.write(realmUser, update: true)
    }
    
    func writePost(_ post: Post) {
        let realmPost = PostRealm(post)
        self.write(realmPost, update: true)
    }
    
}

