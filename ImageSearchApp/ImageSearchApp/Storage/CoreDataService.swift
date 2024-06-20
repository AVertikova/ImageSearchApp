//
//  CoreDataService.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 19.06.2024.
//

import Foundation
import CoreData
import UIKit

protocol IImageSearchDataService {
    func save(image: SearchResultImageViewModel)
}

protocol IDownloadedImagesDataService {
    func fetchImages(completion: ([GalleryImageViewModel]?, Error?) -> Void)
}

final class CoreDataService {
    private let entityName = "ImageEntity"
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageSearchApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

extension CoreDataService: IImageSearchDataService {
    
    func save(image: SearchResultImageViewModel) {
        persistentContainer.performBackgroundTask { context in
            let entity = ImageEntity(context: context)
            entity.id = UUID()
            entity.cathegory = image.cathegory
            if let imageData = image.image?.pngData() {
                entity.imageData = imageData
            }
            self.saveContext(context)
        }
    }
}

extension CoreDataService: IDownloadedImagesDataService {
    
    func fetchImages(completion: ([GalleryImageViewModel]?, Error?) -> Void) {
        let context = persistentContainer.viewContext
        let fetchRequest = ImageEntity.fetchRequest()
        
        do {
            let images = try context.fetch(fetchRequest)
            completion(images.map {
                GalleryImageViewModel(id: $0.id, image: UIImage(data: $0.imageData) ?? UIImage(), cathegory: $0.cathegory)
            }, nil)
        } catch {
            completion(nil, error)
        }
    }
}

private extension CoreDataService {
    
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error occured while saving context.  \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
