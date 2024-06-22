//
//  ImagesGalleryViewController.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import UIKit

protocol IImagesGalleryView: AnyObject {
    func update()
    func setCellSelected(at indexPath: IndexPath)
    func removeItemsAt(_ indexPath: [IndexPath])
}

protocol IImagesGalleryButtonsHandler {
    func selectImagesButtonTapped()
    func removeImagesButtonTapped()
}

class ImagesGalleryViewController: UIViewController {
    private let presenter: IImagesGalleryPresenter
    private let galleryDataSource: IImagesGalleryDataSource
    private let galleryDelegate: IImagesGalleryDelegate
    private var selectedItems: [IndexPath] = []
    private var selectionModeIsOn = false 
    
    private lazy var contentView: ImagesGalleryView = {
        let view = ImagesGalleryView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        view.buttonEventDelegate = self
        
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
    
    func setCellSelected(at indexPath: IndexPath) {
        guard let cell = contentView.collectionView.cellForItem(at: indexPath) as? ImagesGalleryCell else { return }
        cell.isSelected = true
        cell.setSelected()
    }
    
    func removeItemsAt(_ indexPath: [IndexPath]) {
        self.contentView.collectionView.deleteItems(at: indexPath)
    }
}

extension ImagesGalleryViewController: IImagesGalleryButtonsHandler {
    func selectImagesButtonTapped() {
        selectionModeIsOn.toggle()
        update()
    }
    
    func removeImagesButtonTapped() {
        presenter.removeButtonTapped()
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
            
            presenter.configureCell(cell, at: indexPath.section, index: indexPath.item, selectionMode: selectionModeIsOn)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItems.append(indexPath)
        galleryDelegate.imageSelected(at: indexPath.section,
                                      index: indexPath.item,
                                      selectionModeIsOn: selectionModeIsOn)
    }
}

private extension ImagesGalleryViewController {
    func setupAppearance() {
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        navigationItem.title = "Dowloaded images"
        navigationItem.rightBarButtonItems = [contentView.selectImagesButton, contentView.removeImagesButton]
    }
}
