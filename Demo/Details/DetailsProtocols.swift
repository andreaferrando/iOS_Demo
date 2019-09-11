//
//  DetailsProtocols.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//Presenter calls, View listens. Presenter receives a reference from this protocol to access View. View conforms to the protocol
protocol DetailsPresenterToViewProtocol: class {
    var presenter: DetailsViewToPresenterProtocol? { get set }
    
    var showLoadingTrigger: PublishSubject<Double> { get }
    var dismissLoadingTrigger: PublishSubject<Void> { get }
    var showErrorTrigger: PublishSubject<Error> { get }
    
}

//View calls, Presenter listens
protocol DetailsViewToPresenterProtocol: class {
    var view: DetailsPresenterToViewProtocol? { get set }
    
    var data: Variable<DetailViewModel> { get }
    var comments: Variable<[CommentViewModel]> { get }
    
    var viewDidLoadTrigger: PublishSubject<Void> { get }
    var refreshDataTrigger: PublishSubject<Void> { get }
    var goBackTappedTrigger: PublishSubject<Void> { get }
}

//Interactor calls, Presenter listens
protocol DetailsInteractorToPresenterProtocol: class {
    var interactor: DetailsPresenterToInteractorProtocol? { get set }

    func dataDidFetch(post: PostViewModel?, comments: [CommentViewModel]?, user: UserViewModel?, error: Error?)
}

//Presenter calls, Interactor listens
protocol DetailsPresenterToInteractorProtocol: class {
    var presenter: DetailsInteractorToPresenterProtocol? { get set }
    
    func fetchDetails()
}

//Presenter calls, Router listens
protocol DetailsPresenterToRouterProtocol: class {
    var navigationController: UINavigationController? { get set }
    
    func popBack() 
}

//Router calls, Presenter listens
protocol DetailsRouterToPresenterProtocol: class {
    var router: DetailsPresenterToRouterProtocol? { get set }
}

//APIManager calls, Interactor listens
protocol DetailsAPIManagerToInteractorProtocol: class {
    var apiManager: DetailsInteractorToAPIManagerProtocol? { get set }
    
    func postDidFetchFromApi(data: Any?, error: Error?)
    func usersDidFetchFromApi(data: Any, error: Error?)
    func commentsDidFetchFromApi(data: Any, error: Error?)
}

//Interactor calls, APIManager listens
protocol DetailsInteractorToAPIManagerProtocol: class {
    var interactor: DetailsAPIManagerToInteractorProtocol? { get set }
    
    func fetchPost(postId: Int)
    func fetchComments(for postId: Int)
    func fetchUser(userId: Int)
}

//LocalDataManager calls, Interactor listens
protocol DetailsLocalDataManagerToInteractorProtocol: class {
    var localDataManager: DetailsInteractorToLocalDataManagerProtocol? { get set }

}

//Interactor calls, LocalDataManager listens
protocol DetailsInteractorToLocalDataManagerProtocol: class {
    var interactor: DetailsLocalDataManagerToInteractorProtocol? { get set }
    
    func fetchPost(_ postId: Int) -> Post?
    func fetchUser(_ userId: Int) -> User?
    func fetchComments(of postId: Int) -> [Comment]?
    func writeComments(_ comments: [Comment])
    func writeUser(_ user: User)
    func writePost(_ post: Post)
}

//ParseManager calls, Interactor listens
protocol DetailsParseManagerToInteractorProtocol: class {
    var parseManager: DetailsInteractorToParseManagerProtocol? { get set }
}

//Interactor calls, ParseManager listens
protocol DetailsInteractorToParseManagerProtocol: class, PostParsing {
    
    func parseComments(data: Any) -> Result<[Comment], Error>
    func parseUsers(data: Any) -> Result<[User], Error>
    
}




