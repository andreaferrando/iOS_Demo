//
//  DetailsViewTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import Demo

class DetailsViewTests: XCTestCase {

    private var view: DetailsViewController!
    private let presenter = MockPresenter()
    
    override func setUp() {
        super.setUp()
        view = DetailsViewController(nibName: UINavigationController.XibId.details.rawValue, bundle: nil)
        view.presenter = presenter
        presenter.view = view
        view.viewDidLoad()
    }

    func testViewDidLoad() {
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        
        XCTAssertTrue(presenter.didViewLoad)
    }
    
    func testDetailsUpdates() {
        presenter.setTestData()
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(view.lbAuthor.text ?? "", "User: testAuthor")
        XCTAssertEqual(view.lbTitle.text ?? "", "testTitle")
        XCTAssertEqual(view.lbBody.text ?? "", "testBody")
    }

    func testCommentsUpdates() {
        view.viewDidLoad()
        presenter.setTestData()
        let expectation = self.expectation(description: #function)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(view.tableView.numberOfRows(inSection: 0), 1)
        let cell = (view.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailsTableViewCell)
        XCTAssertEqual(cell?.lbAuthor.text ?? "", "\(Constants.author.capitalized): test@test.com")
        XCTAssertEqual(cell?.lbTitle.text ?? "", "testName")
        XCTAssertEqual(cell?.lbBody.text ?? "", "testBody")
    }

    
    
    class MockPresenter: DetailsViewToPresenterProtocol {
        
        var view: DetailsPresenterToViewProtocol?
        
        var data = Variable<DetailViewModel>(DetailViewModel(author: "", title: "", body: ""))
        var comments = Variable<[CommentViewModel]>([CommentViewModel(comment: Comment(id: 0, postId: 0, name: "", email: "", body: ""))])
        
        var viewDidLoadTrigger = PublishSubject<Void>()
        var refreshDataTrigger = PublishSubject<Void>()
        var goBackTappedTrigger = PublishSubject<Void>()
        
        var didGoBack = false
        var didViewLoad = false
        var dataDidFetch = false
        
        private let disposeBag = DisposeBag()
        
        init() {
            viewDidLoadTrigger.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(onNext: {
                self.didViewLoad = true
            })
            .disposed(by: disposeBag)
            
            goBackTappedTrigger.asDriver(onErrorDriveWith: .empty())
                       .drive(onNext: { [weak self] _ in
                        self?.didGoBack = true
                       })
                       .disposed(by: disposeBag)
            
            refreshDataTrigger.asObservable()
            .observeOn(MainScheduler.instance)
            .bind(onNext: { self.dataDidFetch = true })
            .disposed(by: disposeBag)
        }
        
        func setTestData() {
            let details = DetailViewModel(author: "testAuthor", title: "testTitle", body: "testBody")
            let comments = [CommentViewModel(comment: Comment(id: 1, postId: 1, name: "testName", email: "test@test.com", body: "testBody"))]
            self.data.value = details
            self.comments.value = comments
        }
        
    }
    
}



