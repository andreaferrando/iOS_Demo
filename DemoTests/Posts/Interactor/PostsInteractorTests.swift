//
//  PostsInteractorTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class PostsInteractorTests: XCTestCase {

    private let interactor = PostsInteractor()
    private let presenter = MockPresenter()
    private let apiManager = MockAPIManager()
    private let localDataManager = MockLocalDataManager()
    private let parser = PostsParser()
    
    override func setUp() {
        super.setUp()
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

    func testFetchPosts() {
        interactor.fetchPosts()
        XCTAssertTrue(localDataManager.didFetch)
        XCTAssertTrue(apiManager.didFetch)
    }
    
    func testDataDidFetchFromApiSuccesfully() {
        interactor.dataDidFetchFromApi(data:getPostsData(), error:nil)
        XCTAssertTrue(localDataManager.didWrite)
        XCTAssertFalse(presenter.errorBool)
        XCTAssertTrue(presenter.didFetch)
    }
    
    func testDataDidFetchFromApiFailureInvalidData() {
        interactor.dataDidFetchFromApi(data:[1:"d"], error:nil)
        XCTAssertFalse(localDataManager.didWrite)
        XCTAssertTrue(presenter.didFetch)
        XCTAssertTrue(presenter.errorBool)
    }
    
    func testDataDidFetchFromApiFailureError() {
        let error = NSError(domain: "test_domain", code: 404, userInfo: ["message": "test_body"])
        interactor.dataDidFetchFromApi(data:getPosts(), error:error)
        XCTAssertFalse(localDataManager.didWrite)
        XCTAssertTrue(presenter.didFetch)
        XCTAssertTrue(presenter.errorBool)
    }
    

    private func getPosts() -> [[String:Any]] {
        let json = JsonManager.retrieveJsonFileFromBundle(fileName:"Posts")
        guard let data = json as? [[String:Any]] else {
            return []
        }
        return data
    }
    
    private func getPostsData() -> Data {
        return try! JSONSerialization.data(withJSONObject: getPosts(), options: [])
    }
    
    
    class MockPresenter: PostsInteractorToPresenterProtocol {
        var interactor: PostsPresenterToInteractorProtocol?
        var didFetch = false
        var errorBool = false
        
        func postsDidFetch(_ posts: [Post], error: Error?) {
            didFetch = true
            errorBool = error != nil
        }
               
    }
    
    class MockAPIManager: PostsInteractorToAPIManagerProtocol {
        
        var interactor: PostsAPIManagerToInteractorProtocol?
        var didFetch = false
        
        func fetchData() {
            didFetch = true
        }
        
    }
    
    class MockLocalDataManager: PostsInteractorToLocalDataManagerProtocol {
        
        var interactor: PostsLocalDataManagerToInteractorProtocol?
        var didFetch = false
        var didWrite = false
        
        func fetchData() -> [Post]? {
            didFetch = true
            return nil
        }
        
        func writeData(_ data: [Post]) {
            didWrite = true
        }
        
    }
    
}
