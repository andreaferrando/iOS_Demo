//
//  DetailsParser.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class DetailsParser: DetailsInteractorToParseManagerProtocol {

    func parseComments(data: Any) -> Result<[Comment], Error> {
        guard let data = data as? Data else {
            return .failure(NSError(domain: DemoError.Domain.dataFormat.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.parsingInformation.rawValue]))
        }
        guard !data.isEmpty else { return .success([]) }
        do {
            let decoder = JSONDecoder()
            let commentsData = try decoder.decode([Comment].self, from: data)
            return (.success(commentsData))
        } catch let err {
            return (.failure(NSError(domain: DemoError.Domain.parsing.rawValue, code: 404, userInfo: [ Constants.message: err.localizedDescription])))
        }
    }
    
    func parseUsers(data: Any) -> Result<[User], Error> {
        guard let data = data as? Data else {
            return .failure(NSError(domain: DemoError.Domain.dataFormat.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.parsingInformation.rawValue]))
        }
        guard !data.isEmpty else { return .success([]) }
        do {
            let decoder = JSONDecoder()
            let usersData = try decoder.decode([User].self, from: data)
            return (.success(usersData))
        } catch let err {
            return (.failure(NSError(domain: DemoError.Domain.parsing.rawValue, code: 404, userInfo: [ Constants.message: err.localizedDescription])))
        }
    }
    
    
}

