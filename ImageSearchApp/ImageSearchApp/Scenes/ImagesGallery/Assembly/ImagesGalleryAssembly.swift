//
//  ImagesGalleryAssembly.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import UIKit

enum ImagesGalleryAssembly {
    
    struct Dependencies {
        let navigationController: UINavigationController
        let dataService: IImageSearchDataService
    }
    
    static func createModule(with dependecies: Dependencies) -> ImagesGalleryViewController {
        
        let interactor = ImagesGalleryInteractor(dataService: dependecies.dataService)
        let router = ImagesGalleryRouter(navigationController: dependecies.navigationController)
        let presenter = ImagesGalleryPresenter(interactor: interactor, router: router)
        let viewController = ImagesGalleryViewController(presenter: presenter, imagesGalleryDataSource: presenter, imagesGalleryDelegate: presenter)
        
        return viewController
    }
}
