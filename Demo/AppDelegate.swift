//
//  AppDelegate.swift
//
//
//  Created by
//  Copyright © 2019 Andrea Ferrando. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //set root view controller and inject the configuration where appropriate
        setInitialPage(withConfiguration: Configuration())
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}

// MARK: - Initial Page
extension AppDelegate {

    func setInitialPage(withConfiguration config: ConfigurationDelegate) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let navC = SwipeNavigationController(rootViewController: PostsViewController(nibName: nil, bundle: nil))
        //        navC.isNavigationBarHidden = true
        guard let rootVc = PostsRouter.createModule(using: navC, withXibId: UINavigationController.XibId.posts.rawValue) else { return }
        navC.viewControllers = [rootVc]
        window.rootViewController = navC
        window.makeKeyAndVisible()
        self.window = window
    }

}

