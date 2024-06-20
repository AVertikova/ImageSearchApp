//
//  ImagesGalleryPresenter.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import Foundation

protocol IImagesGalleryPresenter {
    func didLoad(ui: IImagesGalleryView)
    func configureCell(_ cell: ImagesGalleryCell, at index: Int)
}

protocol IImagesGalleryDataSource {
    func getNumberOfRows() -> Int
    func getCellForRow(at index: Int) -> GalleryImageViewModel
}

protocol IImagesGalleryDelegate {
    func imageSelected(at index: Int)
}

protocol IImagesGalleryViewUpdateDelegate: AnyObject  {
    
}

final class ImagesGalleryPresenter {
    weak var ui: IImagesGalleryView?
    private var interactor: IImagesGalleryInteractor
    private var router: ImagesGalleryRouter
    
    private var fetchResult: [GalleryImageViewModel] = [] {
        didSet {
            ui?.update()
        }
    }
    
    init(interactor: IImagesGalleryInteractor, router: ImagesGalleryRouter) {
        self.interactor = interactor
        self.router = router
    }
    
}

extension ImagesGalleryPresenter: IImagesGalleryPresenter {
    
    func didLoad(ui: any IImagesGalleryView) {
        self.ui = ui
        interactor.uiUpdater = self
        fetchImages()
    }
    
    func configureCell(_ cell: ImagesGalleryCell, at index: Int) {
        let image = fetchResult[index].image
        cell.configure(with: image)
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDataSource {
    func getNumberOfRows() -> Int {
        return fetchResult.count
    }
    
    func getCellForRow(at index: Int) -> GalleryImageViewModel {
        return fetchResult[index]
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDelegate {
    func imageSelected(at index: Int) {
        guard let sourceVC = self.ui as? ImagesGalleryViewController else {
            fatalError(CommonError.failedToShowModalWindow)
        }
        
        router.showImageModally(with: fetchResult[index].image, at: sourceVC)
    }
}

extension ImagesGalleryPresenter: IImagesGalleryViewUpdateDelegate {
    
}
 
private extension ImagesGalleryPresenter {
    
    func fetchImages() {
        interactor.fetchImages() { [weak self] result, error in
            
            guard let fetchResult = result, error == nil else {
                if let error = error as? NetworkError {
                    Notifier.imageSearchErrorOccured(message: "Error: \(error.description)")
                } else {
                    Notifier.imageSearchErrorOccured(message: "Error: \(String(describing: error?.localizedDescription))")
                }
                return
            }
            self?.fetchResult = fetchResult
        }
    }
}
