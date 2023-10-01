//
//  String.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 26/09/2023.
//

import Foundation

extension Date {
    func toStringFormat(format: String = "dd MMM yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
