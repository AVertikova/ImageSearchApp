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
    private let galleryDataSource: IImagesGalleryDataSource
    private let galleryDelegate: IImagesGalleryDelegate
    
    private lazy var contentView: ImagesGalleryView = {
        let view = ImagesGalleryView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        
        return view
    }()
    
    init(presenter: IImagesGalleryPresenter, galleryDataSource: IImagesGalleryDataSource, galleryDelegate: IImagesGalleryDelegate) {
        self.presenter = presenter
        self.galleryDataSource = galleryDataSource
        self.galleryDelegate = galleryDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load")
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return galleryDataSource.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return galleryDataSource.getNumberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesGalleryCell.identifier, for: indexPath) as? ImagesGalleryCell {
        
            presenter.configureCell(cell, at: indexPath.section, index: indexPath.item)
            cell.isUserInteractionEnabled = true
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
                case UICollectionView.elementKindSectionHeader:
            let headerView = contentView.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
            
            headerView.headerLabel.text = galleryDataSource.getHeader(for: indexPath.section)
                    return headerView
                default:
                    assert(false, "Unexpected element kind")
                }
            }
        func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
            let layoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        
            if elementKind == UICollectionView.elementKindSectionHeader {
                layoutAttributes.frame = CGRect(x: 0.0, y: 0.0, width: 64, height: 44)
            }
            return layoutAttributes
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 24)
    }
}

extension ImagesGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galleryDelegate.imageSelected(at: indexPath.section, index: indexPath.item)
    }
}

private extension ImagesGalleryViewController {
    func setupAppearance() {
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.title = "Dowloaded images"
    }
}
