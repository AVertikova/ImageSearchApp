//
//  ImagesGalleryInteractor.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import Foundation

protocol IImagesGalleryInteractor {
    var uiUpdater: IImagesGalleryViewUpdateDelegate? { get set }
    func fetchImages(completion: @escaping ([GalleryImageViewModel]?, Error?) -> Void)
}

final class ImagesGalleryInteractor {
    private let dataService: IImageSearchDataService
    weak var uiUpdater: IImagesGalleryViewUpdateDelegate?
    
    init(dataService: IImageSearchDataService) {
        self.dataService = dataService
    }
}

extension ImagesGalleryInteractor: IImagesGalleryInteractor {
    func fetchImages(completion: @escaping ([GalleryImageViewModel]?, Error?) -> Void) {
        
    }
    
    
}
