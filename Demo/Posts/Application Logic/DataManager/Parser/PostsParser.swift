//
//  PostsParser.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

protocol PostParsing {
    func parsePost(_ data: Any) -> Post?
}

extension PostParsing {
    func parsePost(_ data: Any) -> Post? {
        guard let data = data as? Data else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Post.self, from: data)
        } catch {
            return nil
        }
    }
}

class PostsParser: PostsInteractorToParseManagerProtocol, PostParsing {

    func parse(data: Any) -> Result<[Post], Error> {
        guard let data = data as? Data else {
            return .failure(NSError(domain: DemoError.Domain.dataFormat.rawValue, code: 404, userInfo: [ Constants.message: DemoError.Body.parsingInformation.rawValue]))
        }
        guard !data.isEmpty else { return .success([]) }
        do {
            let decoder = JSONDecoder()
            let postData = try decoder.decode([Post].self, from: data)
            return (.success(postData))
        } catch let err {
            return (.failure(NSError(domain: DemoError.Domain.parsing.rawValue, code: 404, userInfo: [ Constants.message: err.localizedDescription])))
        }
    }

}

