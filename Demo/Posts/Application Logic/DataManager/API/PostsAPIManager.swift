//
//  PostsAPIManager.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class PostsAPIManager: PostsInteractorToAPIManagerProtocol {

    weak var interactor: PostsAPIManagerToInteractorProtocol?
    var config: ConfigurationDelegate
    var requestManager: APIRequestManager
    
    //Inject Network Layer
    init(config: ConfigurationDelegate, requestManager:APIRequestManager) {
        self.config = config
        self.requestManager = requestManager
    }
    
    func fetchData() {
        if config.isMock() {
            fetchPostsMock()
            return
        }
        guard let url = URL(string:config.baseUrl+"/posts") else { return }
        requestManager.request(url: url, parameters: nil, headers: nil).done({ [weak weakself = self] (data) in
            weakself?.interactor?.dataDidFetchFromApi(data: data, error: nil)
        }).catch { [weak weakself = self] error in
            weakself?.interactor?.dataDidFetchFromApi(data: [], error:error)
        }
    }
    
    private func fetchPostsMock() {
        guard let interactor = self.interactor else { return }
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
        guard let data = json as? [[String:Any]] else {
            return interactor.dataDidFetchFromApi(data: [],
                                                  error:NSError(domain: DemoError.Domain.network.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.retrievingInformation.rawValue]))
        }
        interactor.dataDidFetchFromApi(data: data, error: nil)
    }
    
}
