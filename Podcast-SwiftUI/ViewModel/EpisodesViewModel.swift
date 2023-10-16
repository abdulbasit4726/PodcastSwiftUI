//
//  EpisodesViewModel.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 30/09/2023.
//

import SwiftUI

class EpisodesViewModel: ObservableObject {
    @Published var episodes = [Episode]()
    @Published var isLoading: Bool = false
    
    init(podcast: Podcast?) {
        fetchEpisodes(podcast: podcast)
    }
    
    // MARK: - Functions
    func fetchEpisodes(podcast: Podcast?) {
        guard let feedUrl = podcast?.feedUrl else {return}
        self.isLoading = true
        NetworkService.shared.fetchEpisodes(feedUrl: feedUrl) {[weak self] episodes in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.episodes = episodes
            }
        }
    }
}
