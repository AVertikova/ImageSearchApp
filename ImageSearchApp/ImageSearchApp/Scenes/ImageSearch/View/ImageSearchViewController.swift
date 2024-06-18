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
    private let tableViewDelegate: IImageSearchTableViewDelegate
    
    private var searchBar: UISearchBar = UISearchBar()
    
    private lazy var contentView: ImageSearchView = {
        let view = ImageSearchView()
        view.setDataSource(self)
        view.setTableViewDelegate(tableViewDelegate)
        view.setSearchBarDelegate(self)
        
        return view
    }()
    
    init(presenter: IImageSearchPresenter,
         dataSource: IImageSearchDataSource,
         tableViewDelegate: IImageSearchTableViewDelegate) {
        
        self.presenter = presenter
        self.dataSource = dataSource
        self.tableViewDelegate = tableViewDelegate
        
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
            self.contentView.tableView.reloadData()
        }
    }
    
    func showActivityIndicator() {
        contentView.showActivityIndicator()
    }
    
    func hideActivityIndicator() {
        contentView.hideActivityIndicator()
    }
}

extension ImageSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.getNumberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as? SearchResultCell {
            
            presenter.configureCell(cell, at: indexPath.row)
            cell.delegate = self
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}

extension ImageSearchViewController: ICellButtonsHandler {
    
    func downloadTapped(_ cell: SearchResultCell) {
        
        if let indexPath = contentView.tableView.indexPath(for: cell) {
            
            presenter.startDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func pauseTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.tableView.indexPath(for: cell) {
            presenter.pauseDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func resumeTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.tableView.indexPath(for: cell) {
            presenter.resumeDownloadImage(at: indexPath.row)
            contentView.updateRows(at: indexPath.row)
        }
    }
    
    func cancelTapped(_ cell: SearchResultCell) {
        if let indexPath = contentView.tableView.indexPath(for: cell) {
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
        presenter.performSearch(with: searchText)
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
