//
//  PostsView.swift
//
//  Created by Andrea Ferrando.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

class PostsViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var constraintBottomCollectionView: NSLayoutConstraint!
    var initialConstraintBottomCollectionView: CGFloat = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.attributedTitle = NSAttributedString(string: "")
        rf.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        return rf
    }()
    
    private var topPad: CGFloat = 20
    private var notifications: [NSObjectProtocol] = []
    
    var presenter: PostsViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        presenter?.fetchData()
    }
    
    // MARK: Setup UI
    private func setupNavigationBar() {
        navigationItem.title = "Posts"
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupUI(){
        startObservingKeyboardChanges()
        setupCollectionView()
        setupConstraints()
        self.view.addSubview(placeholderImageLoadingView)
    }
    
    
    private func setupConstraints() {
        initialConstraintBottomCollectionView = constraintBottomCollectionView.constant
    }
    
    // MARK: Setup CollectionView
    private func setupCollectionView() {
        collectionView.register(UINib(nibName: "PostsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PostsCollectionViewCell")
        collectionView.refreshControl = refreshControl
        setupCollectionViewLayout()
    }
    
    
    private func setupCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        layout.itemSize = getCollectionViewLayoutItemSize(width: ScreenSize.SCREEN_WIDTH, height:ScreenSize.SCREEN_HEIGHT, safeArea:Constants.leftSafeArea+Constants.rightSafeArea)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
    }
    
    private func getCollectionViewLayoutItemSize(width: CGFloat, height: CGFloat, safeArea: CGFloat) -> CGSize {
        let marginPad: CGFloat = 20
        let isPortrait = width < height
        let twoColumns = DeviceType.IS_IPAD || isPortrait == false
        let threeColumns = DeviceType.IS_IPAD && isPortrait == false
        var cellWidth: CGFloat = 0
        if threeColumns == true {
            cellWidth = width / 3 - marginPad / 3 - marginPad * 3
        } else {
            let safeAreaPad = isPortrait == false ? safeArea/2 : 0
            cellWidth = twoColumns ? (width / 2 - 3*marginPad - safeAreaPad) : (width - 2*marginPad - safeAreaPad)

        }
        return CGSize(width: cellWidth, height: DeviceType.IS_IPAD ? 260 : 220)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// MARK: - CollectionView DataSource
extension PostsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PostsCollectionViewCell", for: indexPath) as? PostsCollectionViewCell, let data = presenter?.data else {
            return UICollectionViewCell()
        }
        let post = data[indexPath.row]
        cell.set(title: post.title)
        return cell
    }
}

// MARK: - CollectionView Delegate
extension PostsViewController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let posts = presenter?.data else { return }
        presenter?.postDidSelect(post: posts[indexPath.row])
    }
    
}

// MARK: - CollectionView DelegateFlowLayout
extension PostsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: collectionView.bounds.width, height: topPad)
    }
    
}


// MARK: - PostsPresenterToViewProtocol
extension PostsViewController: PostsPresenterToViewProtocol, DismissHudTimeout {
    
    func showLoading(forceToStopAfter delay: Double?) {
        DispatchQueue.main.async {
            self.hud.delegateTimeout = self
            self.placeholderImageLoadingView.isHidden = false
            self.hud.showLoading(delay ?? 0)
        }
    }
    
    func hudTimeout() {
        showError(title: DemoError.Domain.network.rawValue, message: DemoError.Body.timeout.rawValue)
        self.placeholderImageLoadingView.isHidden = true
        showNoDataView()
    }
    
    private func showNoDataView() {
        if self.presenter?.data == nil || (self.presenter?.data != nil && self.presenter!.data.isEmpty) {
            let noDataView = getNoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            collectionView.addSubview(noDataView)
        } else {
            self.noDataView?.removeFromSuperview()
        }
    }
    
    func dismissLoading() {
        DispatchQueue.main.async {
            self.placeholderImageLoadingView.isHidden = true
            self.collectionView.refreshControl?.endRefreshing()
            self.hud.dismissLoading()
        }
    }
    
    func showError(title: String, message: String) {
        DispatchQueue.main.async {
            Alert.present(on: self, title: title, message: message)
            self.showNoDataView()
        }
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}


// MARK: - UISearchBar
extension PostsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            searchBar.text = nil
            presenter?.cancelSearch()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            return
        }
        presenter?.search(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        presenter?.cancelSearch()
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text == nil || (searchBar.text != nil && searchBar.text!.isEmpty) {
            searchBarCancelButtonClicked(searchBar)
            return
        }
        DispatchQueue.main.async {
            searchBar.endEditing(true)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            presenter?.search(text)
        } else {
            searchBarCancelButtonClicked(searchBar)
        }
    }

}


// MARK: - Keyboard
extension PostsViewController: KeyboardAppearingProtocol {
    
    func startObservingKeyboardChanges() {
        startObservingKeyboardChanges(completion: { (keyboardSize, dismiss) in
            dismiss ? (self.keyboardDidDisppear()) : (self.keyboardDidAppear(height: keyboardSize.height))
        })
    }
    
    private func keyboardDidAppear(height:CGFloat) {
        view.layoutIfNeeded()
        constraintBottomCollectionView.constant = initialConstraintBottomCollectionView + height
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func keyboardDidDisppear() {
        view.layoutIfNeeded()
        constraintBottomCollectionView.constant = initialConstraintBottomCollectionView
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Screen Rotation
extension PostsViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = getCollectionViewLayoutItemSize(width: size.width, height: size.height,
                                                                                                                         safeArea: size.width > size.height
                                                                                                                            ? (Constants.leftSafeArea+Constants.rightSafeArea == 0 ? (Constants.topSafeArea*2)
                                                                                                                                : (Constants.leftSafeArea+Constants.rightSafeArea)) : 0 )
    }
}
