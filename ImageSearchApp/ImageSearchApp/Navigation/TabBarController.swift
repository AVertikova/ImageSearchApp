//
//  TabBarController.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
//    private let searchVC = ImageSearchAssembly.createModule(with: <#T##ImageSearchAssembly.Dependencies#>)
//    private let downloadedVC =
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTabs()
    }
    
    private func configureTabs() {
        self.setupView()
        self.setupNavigation()
    }
    
    private func setupView() {
        setupTabBarAppearance()
        setupTabBarIcons()
        setupTitles()
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .label
        tabBar.isTranslucent = false
        tabBar.backgroundColor = .white
    }
    
    private func setupTabBarIcons() {
//        searchVC.tabBarItem.image =
//        downloadedVC.tabBarItem.image =
//
//        searchVC.tabBarItem.title =
//        downloadedVC.tabBarItem.title =
    }
    
    private func setupTitles() {
//        searchVC.title = TabBarModel.shared.profileTitle
//        downloadedVC.title =

    }
    
    private func setupNavigation() {
//        let searchNC = UINavigationController(rootViewController: searchVC)
//        let downloadedNC = UINavigationController(rootViewController: downloadedVC)
        
//        setViewControllers([searchNC, downloadedNC], animated: true)
    }
}
