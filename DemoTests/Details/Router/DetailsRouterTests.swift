//
//  DetailsRouterTests.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import XCTest
@testable import Demo

class DetailsRouterTests: XCTestCase {

    private let router = DetailsRouter()

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateModule() {
        let mockNavC = UINavigationController(rootViewController: DetailsViewController(nibName: nil, bundle: nil))
        let postId = 1
        let vc = DetailsRouter.createModule(using: mockNavC, withXibId: "Details", postId: postId)
        XCTAssertNotNil(vc)
        XCTAssertEqual(mockNavC, (vc!.presenter as? DetailsRouterToPresenterProtocol)?.router?.navigationController)
        XCTAssertNotNil(DetailsRouter.createModule(using: mockNavC, withXibId: "Details", postId: postId))
    }
    
}
