//
//  ImagePreviewModel.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 19.06.2024.
//

import UIKit

final class SelectedImage {
    var image: UIImage {
        didSet {
            delegate?.updateImageView(with: image)
        }
    }
    
    weak var delegate: IImagePreviewDelegate? {
        didSet {
            delegate?.updateImageView(with: image)
        }
    }
    
    init(with image: UIImage) {
        self.image = image
    }
}
