//
//  DownloadItem.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import Foundation

final class DownloadItem {
    
    var isDownloading = false
    var progress: Float = 0
    var resumeData: Data?
    var task: URLSessionDownloadTask?
    var image: ImageObject
    
    init(image: ImageObject) {
        self.image = image
    }
}

