//
//  DetailsPresenterTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift

@testable import Demo

class DetailsPresenterTest: XCTestCase {

    private let presenter = DetailsPresenter()
    private let interactor = MockInteractor(postId: 1)
    private let router = MockRouter()
    private let view = MockDetails()
    
    private let postVM = PostViewModel(post: Post(id: 1, userId: 1, title: "", body: ""))
    private let userVM = UserViewModel(user: User(id: 1, name: "", username: "", email: ""))
    private let commentsVM = [CommentViewModel(comment: Comment(id: 1, postId: 1, name: "", email: "", body: ""))]

    override func setUp() {
        super.setUp()
        presenter.interactor = interactor
        presenter.router = router
        presenter.view = view
    }
    
    func testViewDidLoad() {
        
        presenter.viewDidLoadTrigger.onNext(())
        
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertTrue(view.didShowLoading)
        XCTAssertTrue(interactor.didFetch)
        XCTAssertTrue(interactor.postId == 1)
    }
    
    func testFetchData() {
        presenter.refreshDataTrigger.onNext(())
        XCTAssertTrue(interactor.didFetch)
    }
    
    func testGoBack() {
        presenter.goBackTappedTrigger.onNext(())
        XCTAssertTrue(router.didPopBack)
    }
    
    func testDataDidFetchSuccessfully() {
        presenter.dataDidFetch(post: postVM, comments: commentsVM, user: userVM, error: nil)
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertTrue(view.didDismissLoading)
        
        let detail = presenter.data.value
        XCTAssertEqual(detail.author, userVM.username)
        XCTAssertEqual(detail.title, postVM.title)
        XCTAssertEqual(detail.body, postVM.body)
        
    }
    
    func testDataDidFetchFailNoPost() {
        presenter.dataDidFetch(post: nil, comments: commentsVM, user: userVM, error: nil)
        XCTAssertTrue(view.didShowError)
        XCTAssertTrue(view.didDismissLoading)
    }
    
    func testDataDidFetchFailNoUser() {
        presenter.dataDidFetch(post: postVM, comments: commentsVM, user: nil, error: nil)
        XCTAssertTrue(view.didShowError)
        XCTAssertTrue(view.didDismissLoading)
    }
    
    func testDataDidFetchFailNoComments() {
        presenter.dataDidFetch(post: postVM, comments: nil, user: userVM, error: nil)
        XCTAssertFalse(view.didShowError)
        let detail = presenter.data.value
        XCTAssertEqual(detail.author, userVM.username)
        XCTAssertEqual(detail.title, postVM.title)
        XCTAssertEqual(detail.body, postVM.body)
        XCTAssertTrue(view.didDismissLoading)
    }
    
    func testDataDidFetchFailWithError() {
        let error = NSError(domain: "test_domain", code: 400, userInfo: ["message":"test_body"])
        presenter.dataDidFetch(post: postVM, comments: commentsVM, user: userVM, error: error)
        XCTAssertTrue(view.didShowError)
        XCTAssertTrue(view.didDismissLoading)
    }
    
    class MockInteractor: DetailsPresenterToInteractorProtocol {
        var presenter: DetailsInteractorToPresenterProtocol?
        var didFetch = false
        var postId: Int = 0
        
        init(postId:Int) {
            self.postId = postId
        }
        
        func fetchDetails() {
            didFetch = true
        }
    }

    
    class MockRouter: DetailsPresenterToRouterProtocol {
        
        var didPopBack = false
        
        weak var navigationController: UINavigationController?
        
        var storyboardId: String = ""
        weak var presenter: DetailsPresenter!
        
        func popBack() {
            didPopBack = true
        }
        
    }

    class MockDetails: DetailsPresenterToViewProtocol {
       
        let showLoadingTrigger = PublishSubject<Double>()
        let dismissLoadingTrigger = PublishSubject<Void>()
        let showErrorTrigger = PublishSubject<Error>()
        
        private let disposeBag = DisposeBag()
        
        var presenter: DetailsViewToPresenterProtocol?
        
        var didShowLoading = false
        var didDismissLoading = false
        var didShowError = false
        
        init() {
            showLoadingTrigger.asObservable()
            .observeOn(MainScheduler.instance)
                .bind(onNext: { [weak weakSelf = self] in
                    weakSelf?.showLoading(forceToStopAfter:$0)
                })
            .disposed(by: disposeBag)
            
            showErrorTrigger.asObservable()
            .observeOn(MainScheduler.instance)
                .bind(onNext: { [weak weakSelf = self] error in
                    weakSelf?.showError(title: (error as NSError).domain, message: (error as NSError).userInfo[Constants.message] as? String ?? "")
                })
            .disposed(by: disposeBag)
            
            dismissLoadingTrigger.asObservable()
            .observeOn(MainScheduler.instance)
                .bind(onNext: dismissLoading)
            .disposed(by: disposeBag)

        }
        
        func showLoading(forceToStopAfter delay: Double?) {
            didShowLoading = true
        }

        func dismissLoading() {
            didDismissLoading = true
        }

        func showError(title: String, message: String) {
            didShowError = true
        }

    }
    
}
