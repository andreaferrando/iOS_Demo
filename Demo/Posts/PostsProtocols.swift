//
//  PostsProtocols.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

//Presenter calls, View listens. Presenter receives a reference from this protocol to access View. View conforms to the protocol
protocol PostsPresenterToViewProtocol: class {
    var presenter: PostsViewToPresenterProtocol? { get set }
    
    func refreshData()
    func showLoading(forceToStopAfter delay: Double?)
    func dismissLoading()
    func showError(title: String, message: String) 
}

//View calls, Presenter listens
protocol PostsViewToPresenterProtocol: class {
    var view: PostsPresenterToViewProtocol? { get set }
    var data: [PostViewModel] { get }
    
    func viewDidLoad()
    func fetchData()
    func postDidSelect(post: PostViewModel)
    func search(_ searchText:String)
    func cancelSearch()
}

//Interactor calls, Presenter listens
protocol PostsInteractorToPresenterProtocol: class {
    var interactor: PostsPresenterToInteractorProtocol? { get set }
    
    func postsDidFetch(_ posts:[Post], error:Error?)
}

//Presenter calls, Interactor listens
protocol PostsPresenterToInteractorProtocol: class {
    var presenter: PostsInteractorToPresenterProtocol? { get set }
    
    func fetchPosts()
}

//Presenter calls, Router listens
protocol PostsPresenterToRouterProtocol: class {
    var navigationController: UINavigationController? { get set }
    
    func performSegue(postId:Int)
}

//Router calls, Presenter listens
protocol PostsRouterToPresenterProtocol: class {
    var router: PostsPresenterToRouterProtocol? { get set }
}

//APIManager calls, Interactor listens
protocol PostsAPIManagerToInteractorProtocol: class {
    var apiManager: PostsInteractorToAPIManagerProtocol? { get set }
    
    func dataDidFetchFromApi(data: Any, error: Error?)
}

//Interactor calls, APIManager listens
protocol PostsInteractorToAPIManagerProtocol: class {
    var interactor: PostsAPIManagerToInteractorProtocol? { get set }
    
    func fetchData() 
}

//LocalDataManager calls, Interactor listens
protocol PostsLocalDataManagerToInteractorProtocol: class {
    var localDataManager: PostsInteractorToLocalDataManagerProtocol? { get set }

}

//Interactor calls, LocalDataManager listens
protocol PostsInteractorToLocalDataManagerProtocol: class {
    var interactor: PostsLocalDataManagerToInteractorProtocol? { get set }
    
    func fetchData() -> [Post]? 
    func writeData(_ data:[Post])
}

//ParseManager calls, Interactor listens
protocol PostsParseManagerToInteractorProtocol: class {
    var parseManager: PostsInteractorToParseManagerProtocol? { get set }
}

//Interactor calls, ParseManager listens
protocol PostsInteractorToParseManagerProtocol: class {
    
    func parse(data: Any)  -> Result<[Post], Error>
    
}




