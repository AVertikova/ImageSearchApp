//
//  ImageSearchView.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

final class ImageSearchView: UIView {
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search image with keyword..."
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    var tableView: UITableView = {
        let view = UITableView()
        view.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.rowHeight = 144
        
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    
    init() {
        super.init(frame: .zero)
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(CommonError.requiredInitError)
    }
}

extension ImageSearchView {
    
    func setTableViewDelegate(_ delegate: UITableViewDelegate) {
        tableView.delegate = delegate
    }
    
    func setSearchBarDelegate(_ delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
    }
    
    func setDataSource(_ dataSource: UITableViewDataSource) {
        tableView.dataSource = dataSource
    }
    
    func updateRows(at index: Int) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    
    func updateProgress(at index: Int, progress: Float, totalSize: String) {
        DispatchQueue.main.async { [weak self] in
            if let cell = self?.tableView.cellForRow(at: IndexPath(row: index,
                                                                   section: 0)) as? SearchResultCell {
                cell.updateProgress(progress: progress, totalSize: totalSize)
            }
        }
    }
    
    func showActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.center = center
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

private extension ImageSearchView {
    
    func setupLayout() {
        backgroundColor = .systemBackground
        addSubview(searchBar)
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
            
        ])
    }
}
