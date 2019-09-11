//
//  UINavigationController+Utils.swift
//  VISA Challenger
//
//  Created by Ferrando, Andrea on 12/07/2018.
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {

    enum XibId: String {
        case posts = "Posts"
        case details = "Details"
    }
    
    enum StoryboardId: String {
        case posts = "Posts"
    }
    
    static func getTargetVC(fromStoryboardId id: StoryboardId) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id.rawValue)
    }

}

final class SwipeNavigationController: UINavigationController {

    // MARK: - Lifecycle

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    deinit {
        delegate = nil
        interactivePopGestureRecognizer?.delegate = nil
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        duringPushAnimation = true
        super.pushViewController(viewController, animated: animated)
    }

    fileprivate var duringPushAnimation = false

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

// MARK: - UINavigationControllerDelegate
extension SwipeNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let swipeNavigationController = navigationController as? SwipeNavigationController else { return }

        swipeNavigationController.duringPushAnimation = false
    }

}

// MARK: - UIGestureRecognizerDelegate

extension SwipeNavigationController: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true // default value
        }

        // Disable pop gesture in two situations:
        // 1) when the pop animation is in progress
        // 2) when user swipes quickly a couple of times and animations don't have time to be performed
        return viewControllers.count > 1 && duringPushAnimation == false
    }
}
