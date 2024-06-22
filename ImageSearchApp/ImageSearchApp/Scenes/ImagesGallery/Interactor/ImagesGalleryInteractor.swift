//
//  ImagesGalleryInteractor.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import Foundation

protocol IImagesGalleryInteractor {
    func fetchImages(completion: @escaping ([[GalleryImageViewModel]]?, Error?) -> Void)
    func updateImages(_ images: [GalleryImageViewModel])
}

final class ImagesGalleryInteractor {
    private let dataService: IImagesGalleryDataService
    private var fetchResult: [[GalleryImageViewModel]] = [[]]
    
    init(dataService: IImagesGalleryDataService) {
        self.dataService = dataService
    }
}

extension ImagesGalleryInteractor: IImagesGalleryInteractor {
    
    func fetchImages(completion: @escaping ([[GalleryImageViewModel]]?, Error?) -> Void) {
        dataService.fetchImages() { [weak self] result, error in
            guard let result = result, error == nil else {
                completion(nil, error)
                return
            }
            self?.fetchResult = result
            completion(self?.fetchResult, nil)
        }
    }
    
    func updateImages(_ images: [GalleryImageViewModel]) {
        dataService.removeAll()
        dataService.saveAll(images)
    }
}
