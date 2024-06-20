//
//  ImageSearchInteractor.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

protocol IImageSearchInteractor {
    func newSearchStarted()
    func requestData(with searchQuery: String, completion: @escaping ([SearchResultImageViewModel]?, Error?) -> Void)
    
    func startDownload(_ image: SearchResultImageViewModel)
    func pauseDownload(_ image: SearchResultImageViewModel)
    func resumeDownload(_ image: SearchResultImageViewModel)
    func cancelDownload(_ image: SearchResultImageViewModel)
    
    func getDownloadedImage(at index: Int, completion: @escaping (UIImage?, Error?) -> Void)
}

final class ImageSearchInteractor: NSObject {
    private let downloadService: DownloadService
    private let networkService: INetworkService
    private let dataService: IImageSearchDataService
    
    private var queryResultPageNumber: Int = 1
    private let queryResultTotalPages: Int = 20
    private var query: String = ""
    
    
    weak var uiUpdater: IImageSearchViewUpdateDelegate?
    
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
                                                                "backgroundSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private var results: [ResposeResult] = []
    private var images: [SearchResultImageViewModel] = []
    
    init(downloadService: DownloadService, networkService: INetworkService, dataService: IImageSearchDataService) {
        self.downloadService = downloadService
        self.networkService = networkService
        self.dataService = dataService
        
    }
}

extension ImageSearchInteractor: IImageSearchInteractor {
    
    func newSearchStarted() {
        self.images = []
        self.queryResultPageNumber = 1
    }
    
    func requestData(with searchQuery: String, completion: @escaping ([SearchResultImageViewModel]?, Error?) -> Void ) {
        guard self.queryResultPageNumber <= queryResultTotalPages else { return }
        self.query = searchQuery
        networkService.getSearchResults(searchQuery: searchQuery, pageNumber: self.queryResultPageNumber) { [weak self] response in
            
            switch response {
                
            case .success(let data):
                do {
                    let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                    self?.results = jsonResult.results
                    
                    self?.getPreviewImages { image, error in
                        
                        if let image = image, error == nil {
                            self?.images.append(image)
                        }
                        completion (self?.images, nil)
                    }
                } catch {
                    Notifier.errorOccured(message: "JSON Error: \(String(describing: error))")
                    return
                }
            case .failure(let error):
                completion (nil, error)
            }
            self?.queryResultPageNumber += 1
        }
    }
    
    func getDownloadItem(for imageObject: SearchResultImageViewModel) -> DownloadItem? {
        return downloadService.activeDownloads[imageObject.downloadURL]
    }
    
    func startDownload(_ image: SearchResultImageViewModel) {
        downloadService.downloadsSession = downloadsSession
        downloadService.startDownload(image)
    }
    
    func pauseDownload(_ image: SearchResultImageViewModel) {
        downloadService.pauseDownload(image)
    }
    
    func resumeDownload(_ image: SearchResultImageViewModel) {
        downloadService.resumeDownload(image)
    }
    
    func cancelDownload(_ image: SearchResultImageViewModel) {
        downloadService.cancelDownload(image)
    }
    
    func getDownloadedImage(at index: Int, completion: @escaping (UIImage?, Error?) -> Void) {
        guard images.isEmpty == false, index < images.count  else {
            completion (nil, NetworkError(code: 0, description: "Image not found"))
            return
        }
        let image = self.images.first(where: { $0.index == index } )
        completion(image?.image, nil)
    }
}

extension ImageSearchInteractor: URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                completionHandler()
            }
        }
    }
}

extension ImageSearchInteractor: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        
        guard let sourceURL = downloadTask.originalRequest?.url else {
            return
        }
        
        let downloadItem = downloadService.activeDownloads[sourceURL]
        downloadService.activeDownloads[sourceURL] = nil
        
        if let downloadItem = downloadItem {
            downloadItem.image.downloaded = true
            dataService.save(image: downloadItem.image)
            uiUpdater?.updateDownloadedItem(with: downloadItem.image)
            uiUpdater?.updateRow(at:  downloadItem.image.index)
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard
            let url = downloadTask.originalRequest?.url,
            let downloadItem = downloadService.activeDownloads[url]  else {
            return
        }
        
        guard Float(totalBytesExpectedToWrite) > 0 else { return }
        downloadItem.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
        
        uiUpdater?.updateProgress(at: downloadItem.image.index, progress: downloadItem.progress , totalSize: totalSize)
    }
}

private extension ImageSearchInteractor {
    
    func getPreviewImages(completion: @escaping (SearchResultImageViewModel?, Error?) -> Void ) {
        for (index, result) in results.enumerated() {
            networkService.getPreviewImage(with: result.urls.regular) { image, error in
                if let image = image, error == nil {
                    guard let previewURL = URL(string: result.urls.regular),
                          let downloadURL = URL(string: result.urls.regular) else { return }
                    
                    let image = SearchResultImageViewModel(index: index, id: result.id, previewURL: previewURL, downloadURL: downloadURL, cathegory: self.query, image: image)
                    completion (image, nil)
                } else {
                    completion (nil, error)
                }
            }
        }
    }
}

