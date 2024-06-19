//
//  ImageSearchPresenter.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import Foundation

protocol IImageSearchPresenter {
    func didLoad(ui: IImageView)
    func performNewSearch(with searchQuery: String)
    func updateSearchResult()
    func configureCell(_ cell: SearchResultCell, at index: Int)
    
    func showImagePreview(at index: Int)
    func startDownloadImage(at index: Int)
    func pauseDownloadImage(at index: Int)
    func resumeDownloadImage(at index: Int)
    func cancelDownloadImage(at index: Int)
}

protocol IImageSearchResultDataSource {
    func getNumberOfRows() -> Int
    func getCellForRow(at index: Int) -> ImageViewModel
}

protocol IImageSearchViewUpdateDelegate: AnyObject {
    func updateRow(at index: Int)
    func updateProgress(at index: Int, progress: Float, totalSize: String)
    func updateDownloadedItem(with image: ImageViewModel)
}

protocol IImageSearchResultDelegate {
    func imageSelected(at index: Int)
    func imageDeselected(at index: Int)
}

final class ImageSearchPresenter: NSObject {
    
    weak var ui: IImageView?
    private var interactor: ImageSearchInteractor
    private var router: ImageSearchRouter
    private var searchQuery: String = ""
    
    private var searchResult: [ImageViewModel] = [] {
        didSet {
            ui?.updateUI()
        }
    }
    
    init(interactor: ImageSearchInteractor, router: ImageSearchRouter) {
        self.interactor = interactor
        self.router = router
    }
}

extension ImageSearchPresenter: IImageSearchPresenter {
    
    func didLoad(ui: IImageView) {
        interactor.uiUpdater = self
        self.ui = ui
    }
    
    func performNewSearch(with searchQuery: String) {
        self.searchResult = []
        self.searchQuery = searchQuery
        interactor.newSearchStarted()
        performSearch(with: searchQuery)
    }
    
    func updateSearchResult() {
        performSearch(with: self.searchQuery)
    }
    
    func configureCell(_ cell: SearchResultCell, at index: Int) {
        ui?.hideActivityIndicator()
        
        let imageObject = searchResult[index]
        let downloaded = imageObject.downloaded
        let downloadItem = interactor.getDownloadItem(for: imageObject)
        guard let image = imageObject.image else { return }
        
        cell.configure(with: image, downloaded: downloaded, downloadItem: downloadItem)
    }
    
    func showImagePreview(at index: Int) {
        
        guard let sourceVC = self.ui as? ImageSearchViewController else {
            fatalError(CommonError.failedToShowModalWindow)
        }
        
        guard let image = searchResult[index].image else { return }
        router.showImageModally(with: image, at: sourceVC)
    }
    
    func startDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.startDownload(image)
    }
    
    func pauseDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.pauseDownload(image)
    }
    
    func resumeDownloadImage(at index: Int) {
        
        let image = searchResult[index]
        interactor.resumeDownload(image)
    }
    
    func cancelDownloadImage(at index: Int) {
        let image = searchResult[index]
        interactor.cancelDownload(image)
    }
}

extension ImageSearchPresenter: IImageSearchResultDataSource {
    
    func getNumberOfRows() -> Int {
        return searchResult.count
    }
    
    func getCellForRow(at index: Int) -> ImageViewModel {
        return searchResult[index]
    }
}

extension ImageSearchPresenter: IImageSearchViewUpdateDelegate {
    
    func updateRow(at index: Int) {
        ui?.updateRows(at: index)
    }
    
    func updateProgress(at index: Int, progress: Float, totalSize: String) {
        ui?.updateProgress(at: index, progress: progress, totalSize: totalSize)
    }
    
    func updateDownloadedItem(with image: ImageViewModel) {
        
        if let index = searchResult.firstIndex(where: { $0.id == image.id }) {
            searchResult[index] = image
        }
    }
}

private extension ImageSearchPresenter {
    
    func performSearch(with searchQuery: String) {
        ui?.showActivityIndicator()
        interactor.requestData(with: searchQuery) { [weak self] result, error in
            
            guard let searchResult = result, error == nil else {
                if let error = error as? NetworkError {
                    Notifier.errorOccured(message: "Error: \(error.description)")
                } else {
                    Notifier.errorOccured(message: "Error: \(String(describing: error?.localizedDescription))")
                }
                return
            }
            self?.searchResult = searchResult
        }
    }
}

extension ImageSearchPresenter: IImageSearchResultDelegate {
    
    func imageSelected(at index: Int) {
        if searchResult[index].downloaded == false {
            ui?.showDownloadMenu(at: index)
        } else {
            guard let sourceVC = self.ui as? ImageSearchViewController else {
                fatalError(CommonError.failedToShowModalWindow)
            }
            interactor.getDownloadedImage(at: index) { [weak self] image, error in
                
                guard error == nil else {
                    Notifier.errorOccured(message: error?.localizedDescription ?? "default")
                    return
                }
                
                guard let image = image else { Notifier.errorOccured(message: "image"); return }
                self?.router.showImageModally(with: image, at: sourceVC)
            }
        }
    }
    
    func imageDeselected(at index: Int) {
        ui?.hideDownloadMenu(at: index)
    }
}
