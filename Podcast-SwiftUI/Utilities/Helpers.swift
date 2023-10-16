//
//  Helpers.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 15/10/2023.
//

import UIKit

class Helpers {
    static let shared = Helpers()
    
    func getTabBarHeight() -> CGFloat {
            if UIDevice.current.userInterfaceIdiom == .phone {
                if UIScreen.main.nativeBounds.height == 1136 {
                    // iPhone 5, 5s, SE (1st gen)
                    return 49
                } else if UIScreen.main.nativeBounds.height == 1334 {
                    // iPhone 6, 6s, 7, 8, SE (2nd gen)
                    return 49
                } else if UIScreen.main.nativeBounds.height == 2208 {
                    // iPhone 6 Plus, 6s Plus, 7 Plus, 8 Plus
                    return 49
                } else if UIScreen.main.nativeBounds.height == 2436 {
                    // iPhone X, Xs, 11 Pro, 12 Mini
                    return 83
                } else if UIScreen.main.nativeBounds.height == 2532 {
                    // iPhone 12, 12 Pro
                    return 83
                } else if UIScreen.main.nativeBounds.height == 2688 {
                    // iPhone Xs Max, 11 Pro Max
                    return 83
                } else if UIScreen.main.nativeBounds.height == 2778 {
                    // iPhone 12 Pro Max
                    return 83
                } else {
                    // Default tab bar height for other devices
                    return 49
                }
            }
            return 49 // Default tab bar height for iPads
        }
}
