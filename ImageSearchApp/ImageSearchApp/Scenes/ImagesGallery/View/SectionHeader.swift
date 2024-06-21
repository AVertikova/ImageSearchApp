//
//  SectionHeader.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 21.06.2024.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let identifier = "SectionHeader"
    
    var headerLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAppearance() {
        addSubview(headerLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
}
