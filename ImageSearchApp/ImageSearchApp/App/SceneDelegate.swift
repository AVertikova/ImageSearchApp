//
//  SceneDelegate.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let navigationController = UINavigationController()
        let networkService = NetworkService()
        let downloadService = DownloadService()
        let dataService = CoreDataService()
        
        let dependencies = ImageSearchAssembly.Dependencies(navigationController: navigationController,
                                                            networkService: networkService,
                                                            downloadService: downloadService,
                                                            dataService: dataService)
        
        
        let viewController = ImageSearchAssembly.createModule(with: dependencies)
        navigationController.viewControllers = [viewController]
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

