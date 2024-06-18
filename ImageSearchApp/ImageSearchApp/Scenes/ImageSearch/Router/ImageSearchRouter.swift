//
//  ImageSearchRouter.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

final class ImageSearchRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDownloadedImageModally(with image: UIImage, at sourceVC: ImageSearchViewController) {
        
//        let parameters = ImageViewerAssembly.Parameters(image: image)
//        let destinationVC = ImageViewerAssembly.createModule(parameters: parameters)
//        let imageViewerNavigationController = UINavigationController(rootViewController: destinationVC)
//        sourceVC.present(imageViewerNavigationController, animated: true)
    }
}


