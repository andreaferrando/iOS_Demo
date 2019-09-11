//
//  DetailsView.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: BaseViewController {
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbAuthor: UILabel!
    @IBOutlet weak var lbBody: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var constraintBodyHeight: NSLayoutConstraint!
    @IBOutlet weak var constraintTableViewHeight: NSLayoutConstraint!
    
    private var cellHeight: CGFloat = 100
    
    var presenter: DetailsViewToPresenterProtocol?
    
    let showLoadingTrigger = PublishSubject<Double>()
    let dismissLoadingTrigger = PublishSubject<Void>()
    let showErrorTrigger = PublishSubject<Error>()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setInputRxSwift()
        setOutupRxSwift()
    }
    
    private func setupUI() {
        self.view.insertSubview(whiteLoadingView, belowSubview: self.btnBack)
        lbTitle.text = ""
        lbAuthor.text = ""
        lbBody.text = ""
        tableView.register(UINib(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationItem.setHidesBackButton(true, animated:false)
    }
    
}

// MARK: - UITableViewDataSource
extension DetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.comments.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as? DetailsTableViewCell, let comments = presenter?.comments.value else {
            return UITableViewCell()
        }
        let comment = comments[indexPath.row]
        cell.set(title: comment.title, author:comment.author, body: comment.body)
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension DetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    //to not show separator lines for empty cells
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}

// MARK: - DetailsPresenterToViewProtocol
extension DetailsViewController: DetailsPresenterToViewProtocol, DismissHudTimeout {
    
    func showLoading(forceToStopAfter delay: Double?) {
        self.hud.delegateTimeout = self
        self.whiteLoadingView.isHidden = false
        DispatchQueue.main.async {
            self.hud.showLoading(delay ?? 0)
        }
    }
    
    func hudTimeout() {
        showError(title: DemoError.Domain.network.rawValue, message: DemoError.Body.timeout.rawValue)
        showNoDataView()
    }
    
    func dismissLoading() {
        self.whiteLoadingView.isHidden = true
        DispatchQueue.main.async {
            self.hud.dismissLoading()
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            Alert.present(on: self, title: title, message: message)
            self.showNoDataView()
            self.dismissLoading()
        }
    }
    
    private func showNoDataView() {
        let noDataView = getNoDataView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        view.insertSubview(noDataView, belowSubview: self.btnBack)
    }
    
}


// MARK: RXSwift
extension DetailsViewController {
    
    private func setInputRxSwift() {
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
    
    private func setOutupRxSwift() {
        guard let presenter = self.presenter else { return }
        
        presenter.viewDidLoadTrigger.onNext(())
        
        btnBack.rx.tap.asDriver()
        .drive(presenter.goBackTappedTrigger)
        .disposed(by: disposeBag)
        
        presenter.data.asObservable().subscribe({ [weak weakself = self] in
            guard let data = $0.element, let weakSelf = weakself else { return }
            weakSelf.lbTitle.text = data.title
            weakSelf.lbAuthor.text = Constants.user.capitalized + ": \(data.author)"
            weakSelf.lbBody.text = data.body
            weakSelf.constraintBodyHeight.constant = UILabel.heightForLabel(text: weakSelf.lbBody.text ?? "", font: weakSelf.lbBody.font, width: weakSelf.lbBody.frame.width)
        }).disposed(by: disposeBag)
        
        presenter.comments.asObservable().subscribe({ [weak weakself = self] in
            guard let comments = $0.element, let weakSelf = weakself else { return }
            weakSelf.constraintTableViewHeight.constant = CGFloat(comments.count) * weakSelf.cellHeight
            weakSelf.tableView.reloadData()
        }).disposed(by: disposeBag)

    }
    
}

