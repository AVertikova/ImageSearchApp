//
//  SearchResultImageViewModel.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import UIKit

struct SearchResultImageDTO: Equatable, Hashable {
    let id: String
    let previewURL: URL
    let downloadURL: URL
    let cathegory: String
    let image: UIImage?
    var downloaded = false
}

