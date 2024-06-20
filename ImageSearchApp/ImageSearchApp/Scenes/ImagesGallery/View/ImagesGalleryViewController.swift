//
//  ImagesGalleryViewController.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import UIKit

protocol IImagesGalleryView: AnyObject {
    func update()
    func updateItem(at index: Int)
}

class ImagesGalleryViewController: UIViewController {
    private let presenter: IImagesGalleryPresenter
    private let imagesGalleryDataSource: IImagesGalleryDataSource
    private let imagesGalleryDelegate: IImagesGalleryDelegate
    
    private lazy var contentView: ImagesGalleryView = {
        let view = ImagesGalleryView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        
        return view
    }()
    
    init(presenter: IImagesGalleryPresenter, imagesGalleryDataSource: IImagesGalleryDataSource, imagesGalleryDelegate: IImagesGalleryDelegate) {
        self.presenter = presenter
        self.imagesGalleryDataSource = imagesGalleryDataSource
        self.imagesGalleryDelegate = imagesGalleryDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupAppearance()
    }
    
    override func loadView() {
        view = contentView
    }
}

extension ImagesGalleryViewController: IImagesGalleryView {
    
    func update() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }
    
    func updateItem(at index: Int) {
        contentView.updateItem(at: index)
    }
}

extension ImagesGalleryViewController: INotifierDelegate {
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Something is wrong :(", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ImagesGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imagesGalleryDataSource.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesGalleryCell.identifier, for: indexPath) as? ImagesGalleryCell {
            
            presenter.configureCell(cell, at: indexPath.row)
            cell.isUserInteractionEnabled = true
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension ImagesGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        imagesGalleryDelegate.imageSelected(at: indexPath.item)
    }
}

private extension ImagesGalleryViewController {
    func setupAppearance() {
        navigationItem.title = "Dowloaded images"
    }
}
