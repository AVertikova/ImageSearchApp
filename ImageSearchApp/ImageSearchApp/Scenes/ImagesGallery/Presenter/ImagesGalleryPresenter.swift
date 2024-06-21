//
//  ImagesGalleryPresenter.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//

import Foundation

protocol IImagesGalleryPresenter {
    func didLoad(ui: IImagesGalleryView)
    func configureCell(_ cell: ImagesGalleryCell, at section: Int, index: Int)
}

protocol IImagesGalleryDataSource {
    
    func getNumberOfSections() -> Int
    func getNumberOfItemsInSection(_ section: Int) -> Int
    func getCellForRow(at section: Int, index: Int) -> GalleryImageViewModel
    func getHeader(for section: Int) -> String
}

protocol IImagesGalleryDelegate {
    func imageSelected(at section: Int, index: Int)
}

protocol IImagesGalleryViewUpdateDelegate: AnyObject  {
    
}

final class ImagesGalleryPresenter {
    weak var ui: IImagesGalleryView?
    private var interactor: IImagesGalleryInteractor
    private var router: ImagesGalleryRouter
    
    private var fetchResult: [[GalleryImageViewModel]] = [[]] {
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
        print("presenter did load")
        self.ui = ui
        interactor.uiUpdater = self
        fetchImages()
    }
    
    func configureCell(_ cell: ImagesGalleryCell, at section: Int, index: Int) {
        let image = fetchResult[section][index].image
        cell.configure(with: image)
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDataSource {

    func getNumberOfSections() -> Int {
        return fetchResult.count
    }
    
    func getNumberOfItemsInSection(_ section: Int) -> Int {
        return fetchResult[section].count
    }
    
    
    
    func getCellForRow(at section: Int, index: Int) -> GalleryImageViewModel {
        return fetchResult[section][index]
    }
    
    func getHeader(for section: Int) -> String {
        
        guard let item = fetchResult[section].first else {
            return "Empty Header"
        }
        return item.cathegory
    }
}

extension ImagesGalleryPresenter: IImagesGalleryDelegate {
    func imageSelected(at section: Int, index: Int) {
        guard let sourceVC = self.ui as? ImagesGalleryViewController else {
            fatalError(CommonError.failedToShowModalWindow)
        }
        
        router.showImageModally(with: fetchResult[section][index].image, at: sourceVC)
    }
}

extension ImagesGalleryPresenter: IImagesGalleryViewUpdateDelegate {
    
}
 
private extension ImagesGalleryPresenter {
    
    func fetchImages() {
        print("presenter fetchImages()")
        interactor.fetchImages() { [weak self] result, error in
            
            guard let fetchResult = result, error == nil else {
                print("presenter fetchImages() 2 ", self?.fetchResult.count)
                if let error = error as? NetworkError {
                    Notifier.imageSearchErrorOccured(message: "Error: \(error.description)")
                } else {
                    Notifier.imageSearchErrorOccured(message: "Error: \(String(describing: error?.localizedDescription))")
                }
                return
            }
            self?.fetchResult = fetchResult
            print("presenter fetchImages() ", self?.fetchResult.count)
        }
    }
}
