//
//  ImagePreviewAssembly.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 19.06.2024.
//

import UIKit

enum ImagePreviewAssembly {
    
    struct Parameters {
        let image: UIImage
    }
    
    static func createModule(parameters: Parameters) -> ImagePreviewViewController {
        
        let model = SelectedImage(with: parameters.image)
        let viewController = ImagePreviewViewController(with: model)
        
        return viewController
    }
}
