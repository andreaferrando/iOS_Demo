//
//  PostsRouter.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

class PostsRouter: PostsPresenterToRouterProtocol {

    weak var navigationController: UINavigationController?
    
    
    func performSegue(postId:Int) {
        if let targetVC = DetailsRouter.createModule(using: navigationController, withXibId: UINavigationController.XibId.details.rawValue, postId:postId) {
            self.navigationController?.show(targetVC, sender: nil)
        }
    }
    
    static func createModule(using navigationController:UINavigationController?, withXibId xibId: String) -> PostsViewController? {
        return createModule(withView: PostsViewController(nibName: xibId, bundle: nil), navigationController: navigationController)
    }
    
    static private func createModule(withView view: PostsViewController, navigationController:UINavigationController?) -> PostsViewController {
        // Generating module components
        let presenter: PostsViewToPresenterProtocol & PostsInteractorToPresenterProtocol & PostsRouterToPresenterProtocol = PostsPresenter()
        let interactor: PostsPresenterToInteractorProtocol
            & PostsAPIManagerToInteractorProtocol
            & PostsLocalDataManagerToInteractorProtocol
            & PostsParseManagerToInteractorProtocol = PostsInteractor()
        let apiManager: PostsInteractorToAPIManagerProtocol = PostsAPIManager(config: Configuration(), requestManager: DemoNSURLSessionManager())
        let localDataManager: PostsInteractorToLocalDataManagerProtocol = PostsLocalDataManager()
        let parseManager: PostsInteractorToParseManagerProtocol = PostsParser()
        let router: PostsPresenterToRouterProtocol = PostsRouter()
        router.navigationController = navigationController
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.apiManager = apiManager
        interactor.localDataManager = localDataManager
        interactor.parseManager = parseManager
        apiManager.interactor = interactor
        localDataManager.interactor = interactor
        
        return view
    }
}
