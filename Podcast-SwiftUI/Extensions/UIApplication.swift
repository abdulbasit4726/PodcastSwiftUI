//
//  UIApplication.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 15/10/2023.
//

import UIKit

extension UIApplication {
    var currentWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    
    var firstKeyWindow: UIWindow? {
       connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?.keyWindow
    }
}
