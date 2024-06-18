//
//  ImageSearchInteractor.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

protocol IImageSearchInteractor {
    func newSearchStarted()
    func requestData(with searchQuery: String, completion: @escaping ([ImageObject]?, Error?) -> Void)
    
    func startDownload(_ image: ImageObject)
    func pauseDownload(_ image: ImageObject)
    func resumeDownload(_ image: ImageObject)
    func cancelDownload(_ image: ImageObject)
    
    func getDownloadedImage(at index: Int, completion: @escaping (UIImage?, Error?) -> Void)
}

final class ImageSearchInteractor: NSObject {
    private let downloadService: DownloadService
    private let networkService: INetworkService
    
    private var querryResultPageNumber: Int = 1
    private let querryResultTotalPages: Int = 20
    
    weak var uiUpdater: IImageSearchViewUpdateDelegate?
    
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier:
                                                                "backgroundSession")
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    private var results: [ResposeResult] = []
    private var images: [ImageObject] = []
    private var downloadedImages: [UIImage] = []
    
    init(downloadService: DownloadService, networkService: INetworkService) {
        self.downloadService = downloadService
        self.networkService = networkService
        
    }
}

extension ImageSearchInteractor: IImageSearchInteractor {
    
    func newSearchStarted() {
        self.images = []
        self.querryResultPageNumber = 1
    }
    
    func requestData(with searchQuery: String, completion: @escaping ([ImageObject]?, Error?) -> Void ) {
        guard self.querryResultPageNumber <= querryResultTotalPages else { return }
        networkService.getSearchResults(searchQuery: searchQuery, pageNumber: self.querryResultPageNumber) { [weak self] response in
           
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
            self?.querryResultPageNumber += 1
        }
    }
    
    func getDownloadItem(for imageObject: ImageObject) -> DownloadItem? {
        return downloadService.activeDownloads[imageObject.downloadURL]
    }
    
    func startDownload(_ image: ImageObject) {
        downloadService.downloadsSession = downloadsSession
        downloadService.startDownload(image)
    }
    
    func pauseDownload(_ image: ImageObject) {
        downloadService.pauseDownload(image)
    }
    
    func resumeDownload(_ image: ImageObject) {
        downloadService.resumeDownload(image)
    }
    
    func cancelDownload(_ image: ImageObject) {
        downloadService.cancelDownload(image)
    }
    
    func getDownloadedImage(at index: Int, completion: @escaping (UIImage?, Error?) -> Void){
        guard downloadedImages.isEmpty == false,
              index < downloadedImages.count  else {
            completion (nil, NetworkError(code: 0, description: "Image not found"))
            return
         }
        completion(downloadedImages[index], nil)
    }
}

private extension ImageSearchInteractor {
    
    func getPreviewImages(completion: @escaping (ImageObject?, Error?) -> Void ) {
        for (index, result) in results.enumerated() {
            networkService.getPreviewImage(with: result.urls.regular) { image, error in
                if let image = image, error == nil {
                    guard let previewURL = URL(string: result.urls.regular),
                          let downloadURL = URL(string: result.urls.regular) else { return }
                    
                    let image = ImageObject(index: index, id: result.id, previewURL: previewURL, downloadURL: downloadURL, image: image)
                    completion (image, nil)
                } else {
                    completion (nil, error)
                }
            }
        }
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
        
        if let image = downloadItem?.image.image {
            downloadItem?.image.downloaded = true
            
            if let imageObject = downloadItem?.image {
                uiUpdater?.updateDownloadedItem(with: imageObject)
            }
            
            downloadedImages.append(image)
            
            if let index = downloadItem?.image.index {
                uiUpdater?.updateRow(at:  index)
            }
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

