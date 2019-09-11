//
//  PostInteractor.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class PostsInteractor {
    
    weak var presenter: PostsInteractorToPresenterProtocol?
    var apiManager: PostsInteractorToAPIManagerProtocol?
    var localDataManager: PostsInteractorToLocalDataManagerProtocol?
    var parseManager: PostsInteractorToParseManagerProtocol?

    private func parseData(_ data: Any) -> [Post]? {
        guard let parseManager = self.parseManager else { return nil }
        do {
            let posts = try parseManager.parse(data: data).get()
            return posts
        } catch {
            return nil
        }
    }
    
}

extension PostsInteractor: PostsPresenterToInteractorProtocol {
    
    func fetchPosts() {
        if let data = localDataManager?.fetchData() {
            presenter?.postsDidFetch(data, error: nil)
        }
        apiManager?.fetchData()
    }
    
}


extension PostsInteractor: PostsAPIManagerToInteractorProtocol {
    
    func dataDidFetchFromApi(data: Any, error: Error?) {
        guard let posts = parseData(data), error == nil else {
            let domain = (error as NSError?)?.domain ?? DemoError.Domain.parsing.rawValue
            let body = (error as NSError?)?.localizedDescription ?? DemoError.Body.retrievingInformation.rawValue
            presenter?.postsDidFetch([], error:NSError(domain: domain, code: 404, userInfo: [ Constants.message: body]))
            return
        }
        localDataManager?.writeData(posts)
        presenter?.postsDidFetch(posts, error: nil)
    }
    
}


extension PostsInteractor: PostsLocalDataManagerToInteractorProtocol { }


extension PostsInteractor: PostsParseManagerToInteractorProtocol { }



