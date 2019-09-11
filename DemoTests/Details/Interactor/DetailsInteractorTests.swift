//
//  DetailsInteractorTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class DetailsInteractorTests: XCTestCase {

    private let interactor = DetailsInteractor(postId: 1)
    private let presenter = MockPresenter()
    private let apiManager = MockAPIManager()
    private let localDataManager = MockLocalDataManager()
    private let parser = DetailsParser()
    
    override func setUp() {
        super.setUp()
        interactor.post = Post(id: 1, userId: 1, title: "", body: "")
        interactor.presenter = presenter
        interactor.apiManager = apiManager
        apiManager.interactor = interactor
        interactor.localDataManager = localDataManager
        localDataManager.interactor = interactor
        interactor.parseManager = parser
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFetchDetails() {
        interactor.fetchDetails()
        XCTAssertTrue(localDataManager.didFetchPost)
        XCTAssertTrue(localDataManager.didFetchUser)
        XCTAssertTrue(localDataManager.didFetchComments)
        XCTAssertTrue(apiManager.didFetchUser)
        XCTAssertTrue(apiManager.didFetchComments)
    }
    
    func testUserDidFetchUsersFromApiSuccesfully() {
        interactor.usersDidFetchFromApi(data: getUsersData(), error: nil)
        XCTAssertTrue(localDataManager.didWriteUser)
        XCTAssertFalse(presenter.errorBool)
    }
    
    func testUserDidFetchUsersFromApiFailureInvalidData() {
        interactor.usersDidFetchFromApi(data:[1:"d"], error:nil)
        XCTAssertFalse(localDataManager.didWriteUser)
        XCTAssertFalse(localDataManager.didFetchComments)
        XCTAssertTrue(presenter.errorBool)
    }
    
    func testUserDidFetchUsersFromApiFailureError() {
        let error = NSError(domain: "test_domain", code: 404, userInfo: ["message": "test_body"])
        interactor.usersDidFetchFromApi(data:getUsers(), error:error)
        XCTAssertFalse(localDataManager.didWriteUser)
        XCTAssertFalse(localDataManager.didFetchComments)
        XCTAssertTrue(presenter.errorBool)
    }
    
    func testUserDidFetchCommentsFromApiSuccesfully() {
        interactor.commentsDidFetchFromApi(data: getCommentsData(), error: nil)
        XCTAssertTrue(localDataManager.didWriteComments)
        XCTAssertFalse(presenter.errorBool)
    }
    
    func testUserDidFetchCommentsFromApiFailureInvalidData() {
        interactor.commentsDidFetchFromApi(data:[1:"d"], error:nil)
        XCTAssertFalse(localDataManager.didWriteComments)
        XCTAssertTrue(presenter.errorBool)
    }
    
    func testUserDidFetchCommentsFromApiFailureError() {
        let error = NSError(domain: "test_domain", code: 404, userInfo: ["message": "test_body"])
        interactor.commentsDidFetchFromApi(data:getComments(), error:error)
        XCTAssertFalse(localDataManager.didWriteComments)
        XCTAssertTrue(presenter.errorBool)
    }
    
    func testPostDidFetchUsersFromApiSuccesfully() {
        interactor.postDidFetchFromApi(data: getPostData(), error: nil)
        XCTAssertTrue(localDataManager.didWritePost)
    }

    private func getUsers() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Users")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
    private func getComments() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Comments")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
    private func getPost() -> [String:Any] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
        guard let data = json as? [[String:Any]] else {
            return [:]
        }
        return data.filter{$0["id"] as? Int == 1}.first ?? [:]
    }
    
    private func getPostData() -> Data {
        return try! JSONSerialization.data(withJSONObject: getPost(), options: [])
    }
    
    private func getCommentsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: getComments(), options: [])
    }
    
    private func getUsersData() -> Data {
        return try! JSONSerialization.data(withJSONObject: getUsers(), options: [])
    }
    
    
    class MockPresenter: DetailsInteractorToPresenterProtocol {
        var interactor: DetailsPresenterToInteractorProtocol?
        var didFetch = false
        var errorBool = false
        
        func dataDidFetch(post: PostViewModel?, comments: [CommentViewModel]?, user: UserViewModel?, error: Error?) {
            didFetch = post != nil && comments != nil && user != nil
            errorBool = error != nil
        }

    }
    
    class MockAPIManager: DetailsInteractorToAPIManagerProtocol {
        
        var interactor: DetailsAPIManagerToInteractorProtocol?
        var didFetchComments = false
        var didFetchUser = false
        var didFetchPost = false
        
        func fetchPost(postId: Int) {
            didFetchPost = true
            interactor?.postDidFetchFromApi(data: [], error: nil)
        }
        
        func fetchComments(for postId: Int) {
            didFetchComments = true
            interactor?.commentsDidFetchFromApi(data: [], error: nil)
        }
       
        func fetchUser(userId: Int) {
            didFetchUser = true
            interactor?.usersDidFetchFromApi(data: [], error: nil)
        }
        
    }
    
    class MockLocalDataManager: DetailsInteractorToLocalDataManagerProtocol {
        
        var interactor: DetailsLocalDataManagerToInteractorProtocol?
        var didFetchPost = false
        var didFetchUser = false
        var didFetchComments = false
        var didWriteComments = false
        var didWriteUser = false
        var didWritePost = false
        
        func fetchPost(_ postId: Int) -> Post? {
            didFetchPost = true
            return Post(id: 1, userId: 1, title: "", body: "")
        }
        
        func fetchUser(_ userId: Int) -> User? {
            didFetchUser = true
            return User(id: 1, name: "", username: "", email: "")
        }
        
        func fetchComments(of postId: Int) -> [Comment]? {
            didFetchComments = true
            return [Comment(id: 1, postId: 1, name: "", email: "", body: "")]
        }
        
        func writeComments(_ comments: [Comment]) {
            didWriteComments = true
        }
        
        func writeUser(_ user: User) {
            didWriteUser = true
        }
        
        func writePost(_ post: Post) {
            didWritePost = true
        }
        
    }
    
}
