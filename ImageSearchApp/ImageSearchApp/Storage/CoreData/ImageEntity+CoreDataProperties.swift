//
//  ImageEntity+CoreDataProperties.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 21.06.2024.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var cathegory: String
    @NSManaged public var id: String
    @NSManaged public var imageData: Data

}

extension ImageEntity : Identifiable {

}
