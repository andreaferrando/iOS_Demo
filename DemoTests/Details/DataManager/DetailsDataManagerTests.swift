//
//  DetailsLocalDataManagerTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class DetailsLocalDataManagerTests: XCTestCase {
    
    private let localDataManager = DetailsLocalDataManager()
    
    func testWriteAndFetchUser() {
        //save Details, then retrieve them
        let userId = 1
        let user = getUsers().filter{$0.id == userId}.first
        XCTAssertNotNil(user, "User with id \(userId) not found")
        localDataManager.writeUser(user!)
        XCTAssertEqual(user!, localDataManager.fetchUser(userId))
    }
    
    func testWriteAndFetchComments() {
        //save Details, then retrieve them
        let postId = 1
        let allComments = getComments()
        let comments = allComments.filter{$0.postId == postId}
        localDataManager.writeComments(comments)
        XCTAssertEqual(comments, localDataManager.fetchComments(of: postId))
    }
        
}

class DetailsParserTests: XCTestCase {
    
    private let parser = DetailsParser()
    
    func testParseUsers() {
        let dictionary = getJsonUsers()
        let parsedData = getUsers()
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            XCTAssertFalse(true, "error converting dictionary to Data")
            return
        }
        do {
            let users = try parser.parseUsers(data: data).get()
            XCTAssertEqual(users, parsedData)
        } catch {
            XCTAssertFalse(true)
        }
    }
    
    func testParseComments() {
        let dictionary = getJsonComments()
        let parsedData = getComments()
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            XCTAssertFalse(true, "error converting dictionary to Data")
            return
        }
        do {
            let comments = try parser.parseComments(data: data).get()
            XCTAssertEqual(comments, parsedData)
            XCTAssertTrue(true)
        } catch {
            XCTAssertFalse(true)
        }
    }
    
    private func getJsonUsers() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Users")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
    private func getJsonComments() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Comments")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
}


private func getComments() -> [Comment] {
    let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Comments")
    guard let data = json as? [[String:Any]] else {
        return []
    }
    return data.compactMap{parseSingleComment($0)}
}

private func parseSingleComment(_ data: [String:Any]) -> Comment? {
    guard let id = data["id"] as? Int,
        let postId = data["postId"] as? Int,
        let name = data["name"] as? String,
        let email = data["email"] as? String,
        let body = data["body"] as? String else {
            return nil
    }
    return Comment(id: id, postId: postId, name: name, email: email, body: body)
}

private func getUsers() -> [User] {
    let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Users")
    guard let data = json as? [[String:Any]] else {
        return []
    }
    return data.compactMap{parseSingleUser($0)}
}

private func parseSingleUser(_ data: [String:Any]) -> User? {
    guard let id = data["id"] as? Int,
        let name = data["name"] as? String,
        let email = data["email"] as? String,
        let username = data["username"] as? String else {
            return nil
    }
    return User(id: id, name: name, username: username, email: email)
}
