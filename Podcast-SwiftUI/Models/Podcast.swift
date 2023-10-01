//
//  Podcast.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import Foundation

struct Podcast: Decodable, Identifiable {
    let id: UUID = UUID()
    let trackName: String?
    let artistName: String?
    let artworkUrl600: String?
    let trackCount: Int?
    let feedUrl: String?
}
