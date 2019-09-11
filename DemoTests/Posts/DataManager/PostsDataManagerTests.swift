//
//  PostsLocalDataManagerTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class PostsLocalDataManagerTests: XCTestCase {
    
    private let localDataManager = PostsLocalDataManager()
    
    func testWriteAndFetchData() {
        //save posts, then retrieve them
        let posts = getPosts()
        localDataManager.writeData(posts)
        XCTAssertEqual(posts, localDataManager.fetchData())
    }
        
}

class PostsParserTests: XCTestCase {
    
    private let parser = PostsParser()
    
    func testParser() {
        let dictionary = getJsonPosts()
        let parsedData = getPosts()
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            XCTAssertFalse(true, "error converting dictionary to Data")
            return
        }
        do {
           let posts = try parser.parse(data: data).get()
           XCTAssertEqual(posts, parsedData)
       } catch {
           XCTAssertFalse(true)
       }
    }
    
    private func getJsonPosts() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
}


private func getPosts() -> [Post] {
    let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
    guard let data = json as? [[String:Any]] else {
        return []
    }
    return data.compactMap{parseSinglePost($0)}
}


private func parseSinglePost(_ data: [String:Any]) -> Post? {
    guard let id = data["id"] as? Int,
        let userId = data["userId"] as? Int,
        let title = data["title"] as? String,
        let body = data["body"] as? String else {
            return nil
    }
    return Post(id: id, userId: userId, title: title, body: body)
}
