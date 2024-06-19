//
//  ImageSearchAssembly.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

enum ImageSearchAssembly {
    
    struct Dependencies {
        let navigationController: UINavigationController
        let networkService: INetworkService
        let downloadService: DownloadService
    }
    
    static func createModule(with dependecies: Dependencies) -> ImageSearchViewController {
        
        let interactor = ImageSearchInteractor(downloadService: dependecies.downloadService,
                                               networkService: dependecies.networkService)
        let router = ImageSearchRouter(navigationController: dependecies.navigationController)
        let presenter = ImageSearchPresenter(interactor: interactor, router: router)
        let viewController = ImageSearchViewController(presenter: presenter, dataSource: presenter, delegate: presenter)
        
        return viewController
    }
}
