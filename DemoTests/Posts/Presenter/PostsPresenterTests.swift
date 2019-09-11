//
//  PostsPresenterTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class PostsPresenterTest: XCTestCase {

    private let presenter = PostsPresenter()
    private let interactor = MockInteractor()
    private let router = MockRouter()
    private let view = MockPosts()
    
    override func setUp() {
        super.setUp()
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        XCTAssertTrue(view.didShowLoading)
        XCTAssertTrue(interactor.didFetch)
    }
    
    func testFetchData() {
         presenter.fetchData()
         XCTAssertTrue(interactor.didFetch)
    }
    
    func testSearch() {
        let pv1 = PostViewModel(post: Post(id: 1, userId: 1, title: "abc", body: "aaa"))
        let pv2 = PostViewModel(post: Post(id: 2, userId: 2, title: "bcd", body: "bbb"))
        presenter.unfilteredData = [pv1, pv2]
        presenter.search("b")
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(presenter.data, presenter.unfilteredData)
        presenter.search("c")
        let expectation2 = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation2.fulfill()
        })
        wait(for: [expectation2], timeout: 0.5)
        XCTAssertEqual(presenter.data, presenter.unfilteredData)
        presenter.search("bc")
        let expectation3 = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation3.fulfill()
        })
        wait(for: [expectation3], timeout: 0.5)
        XCTAssertEqual(presenter.data, presenter.unfilteredData)
        presenter.search("bcd")
        let expectation4 = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation4.fulfill()
        })
        wait(for: [expectation4], timeout: 0.5)
        XCTAssertNotEqual(presenter.data, presenter.unfilteredData)
        presenter.search("abc")
        let expectation5 = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation5.fulfill()
        })
        wait(for: [expectation5], timeout: 0.5)
        XCTAssertNotEqual(presenter.data, presenter.unfilteredData)
    }
    
    func testPostDidSelect() {
        let postId = 100
        presenter.postDidSelect(post:PostViewModel(post:Post(id:postId, userId:1, title: "", body: "")))
        XCTAssertTrue(self.router.didPerformedSegue)
        XCTAssertEqual(self.router.postId, postId)
    }
    
    func testPostDidFetchSuccessfully() {
        presenter.postsDidFetch([], error:nil)
        XCTAssertTrue(view.didDismissLoading)
        XCTAssertTrue(view.didRefresh)
    }
    
    func testPostDidFetchFailed() {
        let error = NSError(domain: "test_domain", code: 404, userInfo: ["message": "test_body"])
        presenter.postsDidFetch([], error:error)
        XCTAssertTrue(view.didShowError)
        XCTAssertTrue(view.didDismissLoading)
    }
    
    class MockInteractor: PostsPresenterToInteractorProtocol {
        var presenter: PostsInteractorToPresenterProtocol?
        var didFetch = false
        
        func fetchPosts() {
            didFetch = true
        }
    }

    
    class MockRouter: PostsPresenterToRouterProtocol {
        
        var didPerformedSegue = false
        var postId: Int = 0
        
        weak var navigationController: UINavigationController?
        
        var storyboardId: String = ""
        weak var presenter: PostsPresenter!
        
        func performSegue(postId:Int) {
            self.postId = postId
            didPerformedSegue = true
        }
        
    }

    class MockPosts: PostsPresenterToViewProtocol {
        var presenter: PostsViewToPresenterProtocol?
        
        var didShowLoading = false
        var didDismissLoading = false
        var didShowError = false
        var didRefresh = false
        
        func showLoading(forceToStopAfter delay: Double?) {
            didShowLoading = true
        }
        
        func dismissLoading() {
            didDismissLoading = true
        }
        
        func showError(title: String, message: String) {
            didShowError = true
        }
        
        func refreshData() {
            didRefresh = true
        }
    }
    
}
