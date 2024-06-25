//
//  ImagesGalleryCell.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import UIKit

class ImagesGalleryCell: UICollectionViewCell {
    static let identifier = "ImagesGalleryCell"
    
    var selectionModeCheck: UIImageView = {
        let imageView = UIImageView()
        var config = UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue])
        config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24.0)))
        imageView.preferredSymbolConfiguration = config
        imageView.image = UIImage(systemName: "circle.inset.filled")
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
    func configure(with image: UIImage, selectionModeIsOn: Bool) {
        selectionModeCheck.isHidden = !selectionModeIsOn
        self.setSelected()
        
        self.imageView.image = image
    }
    
    func setSelected() {
        
        if isSelected {
            var config = UIImage.SymbolConfiguration(paletteColors: [.systemBlue, .systemBlue])
            config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24.0)))
            selectionModeCheck.preferredSymbolConfiguration = config
        } else {
            var config = UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue])
            config = config.applying(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 24.0)))
            selectionModeCheck.preferredSymbolConfiguration = config
        }
    }
}

private extension ImagesGalleryCell {
    
    func setConstraints() {
        contentView.addSubview(imageView)
        contentView.addSubview(selectionModeCheck)
        
        
        NSLayoutConstraint.activate([
            
            selectionModeCheck.topAnchor.constraint(equalTo:safeAreaLayoutGuide.topAnchor, constant: 8),
            selectionModeCheck.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            
            imageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
        ])
    }
}
