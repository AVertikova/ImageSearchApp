//
//  Notifier.swift
//  ImageSearchApp
//
//  Created by Анна Вертикова on 18.06.2024.
//

import Foundation

protocol INotifierDelegate {
    func showAlert(message: String)
}

enum Notifier {
    static var imageSearchNotifier: INotifierDelegate?
    static var imagesGalleryNotifier: INotifierDelegate?
    
    static func imageSearchErrorOccured(message: String) {
        DispatchQueue.main.async {
            imageSearchNotifier?.showAlert(message: message)
        }
    }
    
    static func imagesGalleryErrorOccured(message: String) {
        DispatchQueue.main.async {
            imageSearchNotifier?.showAlert(message: message)
        }
    }
}
