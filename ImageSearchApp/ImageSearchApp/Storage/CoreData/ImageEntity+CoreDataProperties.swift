//
//  ImageEntity+CoreDataProperties.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 20.06.2024.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var imageData: Data
    @NSManaged public var id: UUID
    @NSManaged public var cathegory: String

}

extension ImageEntity : Identifiable {

}
