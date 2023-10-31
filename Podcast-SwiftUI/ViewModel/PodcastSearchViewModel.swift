//
//  PodcastSearchViewModel.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 30/09/2023.
//

import SwiftUI

class PodcastSearchViewModel: ObservableObject {
    @Published var podcasts = [Podcast]()
    @Published var isLoading: Bool = false
    var timer: Timer?
    
    // MARK: - Functions
    func handleSearch(searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: {[weak self] _ in
            DispatchQueue.main.async {
                self?.isLoading = true
                self?.podcasts.removeAll()
                NetworkService.shared.fetchPodcasts(searchText: searchText) { [weak self] podcasts in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                        self?.podcasts = podcasts
                    }
                }
            }
        })
    }
}
