//
//  AppDelegate.swift
//  Digid
//
//  Created by Artem Kutasevych on 17.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? ListViewController {
            let viewModel = ListViewModel(networkService: DefaultNetworkService())
            viewController.viewModel = viewModel
            navigationController.viewControllers = [viewController]
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
