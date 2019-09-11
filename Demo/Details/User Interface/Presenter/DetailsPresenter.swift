//
//  ViewControllerPresenter.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DetailsPresenter {
    
    let viewDidLoadTrigger = PublishSubject<Void>()
    let refreshDataTrigger = PublishSubject<Void>()
    let goBackTappedTrigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    weak var view: DetailsPresenterToViewProtocol?
    var interactor: DetailsPresenterToInteractorProtocol?
    var router: DetailsPresenterToRouterProtocol?
    
    var data = Variable<DetailViewModel>(DetailViewModel(author: "", title: "", body: ""))
    var comments = Variable<[CommentViewModel]>([])
    
    init() {
        setInputRxSwift()
    }
    
}

extension DetailsPresenter: DetailsViewToPresenterProtocol {
    
    private func setInputRxSwift() {
        viewDidLoadTrigger.asObservable()
        .observeOn(MainScheduler.instance)
        .bind(onNext: viewDidLoad)
        .disposed(by: disposeBag)
        
        goBackTappedTrigger.asDriver(onErrorDriveWith: .empty())
                   .drive(onNext: { [weak self] _ in
                       self?.router?.popBack()
                   })
                   .disposed(by: disposeBag)
        
        refreshDataTrigger.asObservable()
        .observeOn(MainScheduler.instance)
        .bind(onNext: fetchData)
        .disposed(by: disposeBag)
    }
    
    private func viewDidLoad() {
        view?.showLoadingTrigger.onNext(5)
        self.fetchData()
    }
    
    private func fetchData() {
        interactor?.fetchDetails()
    }
    
}

extension DetailsPresenter: DetailsInteractorToPresenterProtocol {
    
    func dataDidFetch(post: PostViewModel?, comments: [CommentViewModel]?, user: UserViewModel?, error: Error?) {
        view?.dismissLoadingTrigger.onNext(())
        if let err = error {
            view?.showErrorTrigger.onNext(err)
            return
        }
        if let user = user, let post = post {
            self.data.value = DetailViewModel(author: user.username, title: post.title, body: post.body)
        } else {
            let err = NSError(domain: DemoError.Title.dataError.rawValue, code: 400, userInfo: [Constants.message: DemoError.Body.dataNotFound.rawValue])
            view?.showErrorTrigger.onNext(err)
        }
        if let comments = comments {
             self.comments.value = comments
        }
    }
    
}

extension DetailsPresenter: DetailsRouterToPresenterProtocol {
    
}



