//
//  DetailsAPIManager.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class DetailsAPIManager: DetailsInteractorToAPIManagerProtocol {

    weak var interactor: DetailsAPIManagerToInteractorProtocol?
    var config: ConfigurationDelegate
    var requestManager: APIRequestManager
    
    //Inject Network Layer
    init(config: ConfigurationDelegate, requestManager:APIRequestManager) {
        self.config = config
        self.requestManager = requestManager
    }
    
    func fetchPost(postId: Int) {
        if config.isMock() {
            fetchPostMock(postId: postId)
            return
        }
        guard let url = URL(string:config.baseUrl+"/posts/\(postId)") else {
            self.interactor?.postDidFetchFromApi(data: [], error: NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
            return
        }
        requestManager.request(url: url, parameters: nil, headers: nil).done({ [weak weakself = self] (data) in
            weakself?.interactor?.postDidFetchFromApi(data: data, error: nil)
        }).catch { [weak weakself = self] error in
            weakself?.interactor?.postDidFetchFromApi(data: [], error: error)
        }
    }
    
    func fetchComments(for postId: Int) {
        if config.isMock() {
            fetchCommentsMock(for: postId)
            return
        }
        guard let url = URL(string:config.baseUrl+"/comments") else {
             self.interactor?.commentsDidFetchFromApi(data: [], error: NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
            return
        }
        requestManager.request(url: url, parameters: nil, headers: nil).done({ [weak weakself = self] (data) in
            weakself?.interactor?.commentsDidFetchFromApi(data: data, error: nil)
        }).catch { [weak weakself = self] error in
            weakself?.interactor?.commentsDidFetchFromApi(data: [], error:error)
        }
    }
    
     func fetchUser(userId: Int) {
        if config.isMock() {
            fetchUsersMock()
            return
        }
        guard let url = URL(string:config.baseUrl+"/users") else {
            self.interactor?.commentsDidFetchFromApi(data: [], error: NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
                return
            }
        requestManager.request(url: url, parameters: nil, headers: nil).done({ [weak weakself = self] (data) in
            weakself?.interactor?.usersDidFetchFromApi(data: data, error: nil)
        }).catch { [weak weakself = self] error in
            weakself?.interactor?.usersDidFetchFromApi(data: [], error: error)
        }
    }
    
    private func fetchCommentsMock(for postId: Int) {
        guard let interactor = self.interactor else { return }
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Comments")
        guard let data = json as? [[String:Any]]  else {
            return interactor.commentsDidFetchFromApi(data: [],
                                                      error:NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
        }
        let dataComments = data.filter{$0["postId"] as? Int == postId}
        interactor.commentsDidFetchFromApi(data: dataComments, error: nil)
    }
    
    private func fetchUsersMock() {
        guard let interactor = self.interactor else { return }
        let jsonUsers = JsonManager.retrieveJsonFileFromBundle(fileName:"Users")
        guard let data = jsonUsers as? [[String:Any]] else {
            return interactor.usersDidFetchFromApi(data: [],
                                                   error:NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
        }
        interactor.usersDidFetchFromApi(data: data, error: nil)
    }
    
    private func fetchPostMock(postId: Int) {
        guard let interactor = self.interactor else { return }
        let jsonUsers = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
        guard let data = jsonUsers as? [[String:Any]] else {
            return interactor.usersDidFetchFromApi(data: [],
                                                   error:NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
        }
        let post = data.filter{$0["id"] as? Int == postId}.first
        interactor.postDidFetchFromApi(data: post, error: nil)
    }

        
    // MARK: Personal Note: concurrent requests
    /// In this example the operations of fetching comments and users are separated and the Interactor is waiting to fetch users and comments together
    /// and then it merges the two informations and send them to the presenter.
    /// As a showcase, here below there is an example of getting data where there are two concurrent requests and waiting for both of them to finish before returning values
    /*
    func fetchData() {
        guard let url = URL(string:config.baseUrl+"/posts") else { return }
        guard let urlUsers = URL(string:config.baseUrl+"/users") else { return }
        requestManager.request(url: url, parameters: nil, headers: nil).done({ [weak self] (data) in
            self?.requestManager.request( url: urlUsers, parameters: nil, headers: nil).done({ [weak weakself = self] (users) in
                weakself?.interactor?.dataDidFetchFromApi(users: users, comments:comments, error: nil)
            }).catch { [weak weakself = self] error in
                weakself?.interactor?.dataDidFetchFromApi(users: [], comments: [], error:error)
            }
        }).catch { [weak weakself = self] error in
            weakself?.interactor?.dataDidFetchFromApi(users: [], comments: [], error:error)
        }
    }
    */
}
