//
//  SearchResult.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Podcast]
}
