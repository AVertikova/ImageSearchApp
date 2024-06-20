//
//  ImagePreviewViewController.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 19.06.2024.
//

import Foundation

import UIKit

protocol IImagePreviewDelegate: AnyObject {
    func updateImageView(with image: UIImage)
}

class ImagePreviewViewController: UIViewController {
    private let viewModel: SelectedImage
    private lazy var contentView = ImagePreviewView()
    
    init(with viewModel: SelectedImage) {
        
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setDismissButtonTappedEvent()
    }
    
    override func loadView() {
        view = contentView
    }
}

extension ImagePreviewViewController: IImagePreviewDelegate {
    
    func updateImageView(with image: UIImage) {
        contentView.fullImageView.image = image
    }
}

private extension ImagePreviewViewController {
    
    func setupAppearance() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = contentView.dismissButton
    }
    
    func setDismissButtonTappedEvent() {
        contentView.dismissButtonHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
