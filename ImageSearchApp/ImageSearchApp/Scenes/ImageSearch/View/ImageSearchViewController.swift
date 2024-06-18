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
}

class ImageSearchViewController: UIViewController {
    
    private let presenter: IImageSearchPresenter
    private let dataSource: IImageSearchDataSource
    private let collectionViewDelegate: IImageSearchCollectionViewDelegate
    
    private var searchBar: UISearchBar = UISearchBar()
    
    private lazy var contentView: ImageSearchView = {
        let view = ImageSearchView()
        view.setCollectionViewDataSource(self)
        view.setCollectionViewDelegate(self)
        view.setSearchBarDelegate(self)
        
        return view
    }()
    
    init(presenter: IImageSearchPresenter,
         dataSource: IImageSearchDataSource,
         tableViewDelegate: IImageSearchCollectionViewDelegate) {
        
        self.presenter = presenter
        self.dataSource = dataSource
        self.collectionViewDelegate = tableViewDelegate
        
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
    }
    
    override func loadView() {
        view = contentView
        navigationItem.title = "Search"
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
}

extension ImageSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.getNumberOfRows()
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
        if indexPath.row == dataSource.getNumberOfRows() - 1 {
            presenter.updateSearchResult()
        }
    }
}

extension ImageSearchViewController: ICellButtonsHandler {
    
    func downloadTapped(_ cell: SearchResultCell) {
        
        if let indexPath = contentView.collectionView.indexPath(for: cell) {
            
            presenter.startDownloadImage(at: indexPath.row)
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

private extension ImageSearchViewController {
    
    func setupNavigationBar() {
        contentView.setSearchBarDelegate(self)
    }
    
    func setupNotifications() {
        Notifier.notificationDelegate = self
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

extension ImageSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
//            
//            let download = UIAction(title: "Download", image: UIImage(systemName: "square.and.arrow.down"), identifier: nil, discoverabilityTitle: nil, state: .off) { (_) in
//                print("edit button clicked")
//            }
//            
//            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [download])
//        }
//        return configuration
//    }
}
