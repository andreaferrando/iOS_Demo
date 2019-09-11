//
//  ViewControllerPresenter.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation

class PostsPresenter {
    
    weak var view: PostsPresenterToViewProtocol?
    var interactor: PostsPresenterToInteractorProtocol?
    var router: PostsPresenterToRouterProtocol?
    
    var data = [PostViewModel]()
    var unfilteredData = [PostViewModel]()
    
    private var searchText: String?
    
    private func filterData() {
        guard let text = searchText, !text.isEmpty else {
            data = unfilteredData
            return
        }
        //make it not case sensitive
        data = unfilteredData.filter{$0.title.lowercased().contains(text.lowercased())}
    }
    
}

// MARK: - FromView
extension PostsPresenter: PostsViewToPresenterProtocol {
    
    func viewDidLoad() {
        self.view?.showLoading(forceToStopAfter: 5)
        self.fetchData()
    }
    
    func fetchData() {
        interactor?.fetchPosts()
    }
    
    func postDidSelect(post: PostViewModel) {
        self.router?.performSegue(postId:post.id)
    }
    
    // MARK: Search
    func search(_ searchText:String) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.searchText = searchText
            self?.filterData()
            DispatchQueue.main.async {
                self?.view?.refreshData()
            }
        }
    }
    
    func cancelSearch() {
        searchText = nil
        filterData()
        view?.refreshData()
    }
    
}

// MARK: - From Interactor
extension PostsPresenter: PostsInteractorToPresenterProtocol {
    
    func postsDidFetch(_ posts:[Post], error: Error?) {
        view?.dismissLoading()
        self.unfilteredData = posts.map{PostViewModel(post: $0)}
        filterData()
        if let err = error {
            view?.showError(title: (err as NSError).domain, message: (err as NSError).userInfo[Constants.message] as? String ?? "" )
            resetData()
        }
        view?.refreshData()
    }

    private func resetData() {
        self.unfilteredData = []
        self.data = []
    }
}

// MARK: - From Router
extension PostsPresenter: PostsRouterToPresenterProtocol {
    
}



