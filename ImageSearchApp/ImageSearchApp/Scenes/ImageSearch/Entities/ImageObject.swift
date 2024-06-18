//
//  ImageObject.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

struct ImageObject: Equatable {
    let index: Int
    let id: String
    let previewURL: URL
    let downloadURL: URL
    let image: UIImage?
    var downloaded = false
}


