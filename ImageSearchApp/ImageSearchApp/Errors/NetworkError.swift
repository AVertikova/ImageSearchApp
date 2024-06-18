//
//  NetworkError.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import Foundation

struct NetworkError: Error {
    let code: Int
    let description: String
}
