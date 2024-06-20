//
//  APIResponse.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import Foundation

struct APIResponse: Codable {
    let results: [ResposeResult]
}

struct ResposeResult: Codable {
    let id: String
    let urls: URLS
}

struct URLS: Codable {
    let full: String
    let small: String
}
