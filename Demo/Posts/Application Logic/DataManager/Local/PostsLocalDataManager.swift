//
//  PostsDataManager.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class PostsLocalDataManager: DataManagerRealm, PostsInteractorToLocalDataManagerProtocol {

    weak var interactor: PostsLocalDataManagerToInteractorProtocol?
  
    func fetchData() -> [Post]? {
        let realmPosts = Array(realm.objects(PostRealm.self))
        return realmPosts.map{Post(postRealm:$0)}
    }
    
    func writeData(_ data: [Post]){
        let realmPosts = data.compactMap{PostRealm($0)}
        self.write(realmPosts, update: true)
    }
      
}
