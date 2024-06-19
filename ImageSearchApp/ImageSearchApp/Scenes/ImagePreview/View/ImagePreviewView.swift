//
//  ImagePreviewView.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 19.06.2024.
//

import UIKit

class ImagePreviewView: UIView {
    
    var dismissButtonHandler: (()->Void)?
    
    lazy var dismissButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .close,
                                     target: self,
                                     action: #selector(dismissButtonTapped))
        return button
    }()
    
    
    
    lazy var fullImageView: UIImageView = {
        let fullImage = UIImageView()
        fullImage.contentMode = .scaleAspectFit
        fullImage.translatesAutoresizingMaskIntoConstraints = false
        return fullImage
    }()
}

extension ImagePreviewView {
    func setupLayout() {
        setupView()
    }
}

private extension ImagePreviewView {
    
    func setupView() {
        addSubview(fullImageView)
        
        NSLayoutConstraint.activate([
            fullImageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            fullImageView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            fullImageView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            fullImageView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    @objc func dismissButtonTapped() {
        dismissButtonHandler?()
    }
    
}

