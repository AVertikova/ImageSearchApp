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
    
    func showImageModally(with image: UIImage, at sourceVC: ImageSearchViewController) {
        
        let parameters = ImagePreviewAssembly.Parameters(image: image)
        let destinationVC = ImagePreviewAssembly.createModule(parameters: parameters)
        let imageViewerNavigationController = UINavigationController(rootViewController: destinationVC)
        sourceVC.present(imageViewerNavigationController, animated: true)
    }
    
    func showGallery() {
        
    }
}
