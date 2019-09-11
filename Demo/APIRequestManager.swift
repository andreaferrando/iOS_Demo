//
//  AlamofireManager.swift
//  Demo
//
//  Created by Ferrando, Andrea on 23/08/2019.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import PromiseKit

protocol APIRequestManager {
    func request(url: URL, parameters: [String : Any]?, headers: [String: String]?) -> Promise<Any>
}

class DemoNSURLSessionManager: APIRequestManager {
 
    func request(url: URL, parameters: [String : Any]?, headers: [String: String]?) -> Promise<Any> {
        return Promise { seal in
            URLSession.shared.dataTask(with: url) { (data, _, error) in
                //data, response, error
                guard error == nil else {
                    let err = NSError(domain: DemoError.Domain.network.rawValue, code:400, userInfo: [ Constants.message: String(describing: error!.localizedDescription)])
                    seal.reject(err)
                    return
                }
                 guard let data = data else {
                    let error = NSError(domain: DemoError.Domain.network.rawValue, code:400, userInfo: [ Constants.message: DemoError.Body.retrievingInformation])
                    seal.reject(error)
                    return
                 }
                seal.fulfill(data)
            }.resume()
        }
    }
        
}
