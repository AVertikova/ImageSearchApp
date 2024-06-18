//
//  ImageSearchPresenter.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit // убрать uikit добавить доп делегат UICollectionViewDelegate перенести в китовое
protocol IImageSearchPresenter {
    func didLoad(ui: IImageView)
    func performNewSearch(with searchQuery: String)
    func updateSearchResult()
    func configureCell(_ cell: SearchResultCell, at index: Int)
    
    func startDownloadImage(at index: Int)
    func pauseDownloadImage(at index: Int)
    func resumeDownloadImage(at index: Int)
    func cancelDownloadImage(at index: Int)
}

protocol IImageSearchDataSource {
    func getNumberOfRows() -> Int
    func getCellForRow(at index: Int) -> ImageObject
}

protocol IImageSearchViewUpdateDelegate: AnyObject {
    func updateRow(at index: Int)
    func updateProgress(at index: Int, progress: Float, totalSize: String)
    func updateDownloadedItem(with image: ImageObject)
}

protocol IImageSearchCollectionViewDelegate: UICollectionViewDelegate {}

final class ImageSearchPresenter: NSObject {
    
    weak var ui: IImageView?
    private var interactor: ImageSearchInteractor
    private var router: ImageSearchRouter
    private var searchQuerry: String = ""
    
    private var searchResult: [ImageObject] = [] {
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
        self.searchQuerry = searchQuery
        interactor.newSearchStarted()
        performSearch(with: searchQuery)
    }
    
    func updateSearchResult() {
        performSearch(with: self.searchQuerry)
    }
    
    func configureCell(_ cell: SearchResultCell, at index: Int) {
        ui?.hideActivityIndicator()
        
        let imageObject = searchResult[index]
        let downloaded = imageObject.downloaded
        let downloadItem = interactor.getDownloadItem(for: imageObject)
        guard let image = imageObject.image else { return }
        
        cell.configure(with: image, downloaded: downloaded, downloadItem: downloadItem)
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

extension ImageSearchPresenter: IImageSearchDataSource {
    
    func getNumberOfRows() -> Int {
        return searchResult.count
    }
    
    func getCellForRow(at index: Int) -> ImageObject {
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
    
    func updateDownloadedItem(with image: ImageObject) {
        
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

extension ImageSearchPresenter: IImageSearchCollectionViewDelegate {
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        guard let sourceVC = self.ui as? ImageSearchViewController else {
//            fatalError(CommonError.failedToShowModalWindow)
//        }
//        
//        if searchResult[indexPath.row].downloaded {
//            
//            interactor.getDownloadedImage(at: indexPath.row) { [weak self] image, error in
//                
//                guard let image = image, error == nil else {
//                    Notifier.errorOccured(message: CommonError.failedToLoadData)
//                    return
//                }
//                
//                self?.router.showDownloadedImageModally(with: image, at: sourceVC)
//            }
//        } else {
//            Notifier.errorOccured(message: CommonError.imageNotDownloaded)
//        }
//    }
}
