//
//  PostsRouterTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class PostsRouterTests: XCTestCase {

    private let router = PostsRouter()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateModule() {
        let mockNavC = UINavigationController(rootViewController: PostsViewController(nibName: nil, bundle: nil))
        let vc = PostsRouter.createModule(using: mockNavC, withXibId: "Posts")
        XCTAssertNotNil(vc)
        XCTAssertEqual(mockNavC, (vc!.presenter as? PostsRouterToPresenterProtocol)?.router?.navigationController)
        XCTAssertNotNil(PostsRouter.createModule(using: mockNavC, withXibId: "Posts"))
    }
    
}
