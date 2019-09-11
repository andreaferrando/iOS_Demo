//
//  DetailsInteractor.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class DetailsInteractor {
    
    weak var presenter: DetailsInteractorToPresenterProtocol?
    var apiManager: DetailsInteractorToAPIManagerProtocol?
    var localDataManager: DetailsInteractorToLocalDataManagerProtocol?
    var parseManager: DetailsInteractorToParseManagerProtocol?

    var post: Post?
    private var postId: Int!
    private var user: User?
    private var comments: [Comment]?
    
    init(postId: Int) {
        self.postId = postId
    }
    
    private func parsePost(_ data: Any) -> Post? {
        guard let parseManager = self.parseManager else { return nil }
        return parseManager.parsePost(data)
    }
    
    private func parseUsers(_ data: Any) -> [User]? {
        guard let parseManager = self.parseManager else { return nil }
        do {
            return try parseManager.parseUsers(data: data).get()
        } catch {
            return nil
        }
    }
    
    private func parseComments(_ data: Any) -> [Comment]? {
        guard let parseManager = self.parseManager else { return nil }
        do {
            return try parseManager.parseComments(data: data).get()
        } catch {
            return nil
        }
    }
    
}

extension DetailsInteractor: DetailsPresenterToInteractorProtocol {
    
    func fetchDetails() {
        ///get post from local storage, otherwise if not found, get from API.
        ///alternatively,  the PostViewModel could be to inject  instead of the postId
        ///however in the Details page, there could be the need to display more info about the Post that PostViewModel of the 'posts' page doesn't have it,
        ///but, instead, retrieving the post for the local data storage guarantees to have all the needed information
        if let post = localDataManager?.fetchPost(postId) {
            self.post = post
            getUserAndComments()
        } else {
            apiManager?.fetchPost(postId: postId)
        }
    }
    
    private func getUserAndComments() {
        guard let post = self.post else {
            presenter?.dataDidFetch(post: nil, comments: nil, user: nil,
                                    error: NSError(domain: DemoError.Domain.parsing.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
            return
        }
        if let user = localDataManager?.fetchUser(post.userId),
            let comments = localDataManager?.fetchComments(of: postId) {
            self.user = user
            self.comments = comments
            presenter?.dataDidFetch(post: PostViewModel(post: post), comments: comments.compactMap{CommentViewModel(comment: $0)}, user: UserViewModel(user: user), error: nil)
        } else {
            //error
        }
        //load from APIs
        apiManager?.fetchUser(userId: post.userId)
        apiManager?.fetchComments(for: post.id)
    }
    
}


extension DetailsInteractor: DetailsAPIManagerToInteractorProtocol {

    func postDidFetchFromApi(data: Any?, error: Error?) {
        guard let dataPost = data, let post = parsePost(dataPost), error == nil else {
            let domain = (error as NSError?)?.domain ?? DemoError.Domain.parsing.rawValue
            let body = (error as NSError?)?.localizedDescription ?? DemoError.Body.retrievingInformation.rawValue
            presenter?.dataDidFetch(post:nil, comments:nil, user:nil, error:NSError(domain: domain, code: 404, userInfo: [ Constants.message: body]))
            return
        }
        self.post = post
        localDataManager?.writePost(post)
        getUserAndComments()
    }
    
    func usersDidFetchFromApi(data: Any, error: Error?) {
        guard let post = checkForPost() else { return }
        guard let users = parseUsers(data), error == nil else {
            let domain = (error as NSError?)?.domain ?? DemoError.Domain.parsing.rawValue
            let body = (error as NSError?)?.localizedDescription ?? DemoError.Body.retrievingInformation.rawValue
            presenter?.dataDidFetch(post:nil, comments:nil, user:nil, error:NSError(domain: domain, code: 404, userInfo: [ Constants.message: body]))
            return
        }
        let userFiltered = users.filter{$0.id == post.userId}.first
        if let user = userFiltered {
            self.user = user
            localDataManager?.writeUser(user)
        }
        returnDataToPresenter()
    }
    
    func commentsDidFetchFromApi(data: Any, error: Error?) {
        guard let post = checkForPost() else { return }
        guard let comments = parseComments(data), error == nil else {
            let domain = (error as NSError?)?.domain ?? DemoError.Domain.parsing.rawValue
            let body = (error as NSError?)?.localizedDescription ?? DemoError.Body.retrievingInformation.rawValue
            presenter?.dataDidFetch(post: nil, comments: nil, user: nil, error:NSError(domain: domain, code: 404, userInfo: [ Constants.message: body]))
            return
        }
        self.comments = comments.filter{$0.postId == post.id}
        localDataManager?.writeComments(comments)
        returnDataToPresenter()
    }
    
    private func returnDataToPresenter() {
        if let post = self.post, let user = self.user, let comments = self.comments {
            presenter?.dataDidFetch(post: PostViewModel(post: post), comments: comments.compactMap{CommentViewModel(comment: $0)}, user: UserViewModel(user: user), error: nil)
        }
    }
    
    private func checkForPost() -> Post? {
        guard let post = self.post else {
            presenter?.dataDidFetch(post:nil, comments:nil, user:nil,
                                    error:NSError(domain: DemoError.Title.dataError.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.dataNotFound.rawValue]))
            return nil
        }
        return post
    }
}


extension DetailsInteractor: DetailsLocalDataManagerToInteractorProtocol { }


extension DetailsInteractor: DetailsParseManagerToInteractorProtocol { }



