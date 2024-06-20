//
//  ImageSearchViewController.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

protocol IImageView: AnyObject {
    func updateUI()
    func updateRows(at index: Int)
    func updateProgress(at index: Int, progress: Float, totalSize: String)
    
    func showActivityIndicator()
    func hideActivityIndicator()
    
    func showDownloadMenu(at index: Int)
    func hideDownloadMenu(at index: Int)
}

protocol ICellButtonsHandler {
    func downloadTapped(_ cell: SearchResultCell)
    func previewTapped(_ cell: SearchResultCell)
    func pauseTapped(_ cell: SearchResultCell)
    func resumeTapped(_ cell: SearchResultCell)
    func cancelTapped(_ cell: SearchResultCell)
}


class ImageSearchViewController: UIViewController {
    
    private let presenter: IImageSearchPresenter
    private let searchResultDataSource: IImageSearchResultDataSource
    private let searchResultDelegate: IImageSearchResultDelegate
    
    private var searchBar: UISearchBar = UISearchBar()
    
    private lazy var contentView: ImageSearchView = {
        let view = ImageSearchView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        view.setSearchBarDelegate(self)
        
        return view
    }()
    
    init(presenter: IImageSearchPresenter,
         dataSource: IImageSearchResultDataSource,
         delegate: IImageSearchResultDelegate) {
        
        self.presenter = presenter
        self.searchResultDataSource = dataSource
        self.searchResultDelegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad(ui: self)
        setupNotifications()
        setShowGalleryButtonTappedEvent()
    }
    
    override func loadView() {
        view = contentView
        navigationItem.title = "ImageSearch"
    }
}

extension ImageSearchViewController: IImageView {
    
    func updateRows(at index: Int) {
        contentView.updateRows(at: index)
    }
    
    func updateProgress(at index: Int, progress: Float, totalSize: String) {
        contentView.updateProgress(at: index, progress: progress, totalSize: totalSize)
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.contentView.collectionView.reloadData()
        }
    }
    
    func showActivityIndicator() {
        contentView.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        contentView.hideActivityIndicator()
    }
    
    func showDownloadMenu(at index: Int) {
        if let cell = contentView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SearchResultCell  {
            cell.showDownloadMenu()
        }
    }
    
    func hideDownloadMenu(at index: Int) {
        if let cell = contentView.collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? SearchResultCell {
            cell.hideDownloadMenu()
        }
    }
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResultDataSource.getNumberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell {
            
            presenter.configureCell(cell, at: indexPath.row)
            cell.delegate = self
            cell.isUserInteractionEnabled = true
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchResultDataSource.getNumberOfRows() - 1 {
            presenter.updateSearchResult()
        }
    }
}

extension ImageSearchViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchResultDelegate.imageSelected(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        searchResultDelegate.imageDeselected(at: indexPath.item)
    }
}

extension ImageSearchViewController: ICellButtonsHandler {
    
    func downloadTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.startDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func previewTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.showImagePreview(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.pauseDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.resumeDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            presenter.cancelDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
}

extension ImageSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        presenter.performNewSearch(with: searchText)
    }
}

extension ImageSearchViewController: INotifierDelegate {
    
    func showAlert(message: String) {
        if  contentView.activityIndicator.isAnimating {
            hideActivityIndicator()
        }
        
        let alert = UIAlertController(title: "Something is wrong :(", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

private extension ImageSearchViewController {
    
    func setupNavigationBar() {
        contentView.setSearchBarDelegate(self)
    }
    
    func setupNotifications() {
        Notifier.notificationDelegate = self
    }
    
    func setShowGalleryButtonTappedEvent() {
        contentView.showGalleryButtonHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
