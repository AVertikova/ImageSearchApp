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

final class Notifier {
    static let shared = Notifier()
    
    static var notificationDelegate: INotifierDelegate?
    
    private init() {}
    
    static func errorOccured(message: String) {
        DispatchQueue.main.async {
            notificationDelegate?.showAlert(message: message)
        }
    }
    
}
