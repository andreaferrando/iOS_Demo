//
//  DetailsRouter.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

class DetailsRouter: DetailsPresenterToRouterProtocol {

    weak var navigationController: UINavigationController?
    
    func popBack() {
        navigationController?.popViewController(animated: true)
    }
    
    static func createModule(using navigationController:UINavigationController?, withXibId xibId: String, postId:Int) -> DetailsViewController? {
        let detailsVc = DetailsViewController(nibName: xibId, bundle: nil)
        return createModule(withView: detailsVc, navigationController: navigationController, postId:postId)
    }
    
    static private func createModule(withView view: DetailsViewController, navigationController:UINavigationController?, postId:Int) -> DetailsViewController {
        // Generating module components
        let presenter: DetailsViewToPresenterProtocol & DetailsInteractorToPresenterProtocol & DetailsRouterToPresenterProtocol = DetailsPresenter()
        let interactor: DetailsPresenterToInteractorProtocol
            & DetailsAPIManagerToInteractorProtocol
            & DetailsLocalDataManagerToInteractorProtocol
            & DetailsParseManagerToInteractorProtocol = DetailsInteractor(postId:postId)
        let apiManager: DetailsInteractorToAPIManagerProtocol = DetailsAPIManager(config: Configuration(), requestManager: DemoNSURLSessionManager())
        let localDataManager: DetailsInteractorToLocalDataManagerProtocol = DetailsLocalDataManager()
        let parseManager: DetailsInteractorToParseManagerProtocol = DetailsParser()
        let router: DetailsPresenterToRouterProtocol = DetailsRouter()
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
