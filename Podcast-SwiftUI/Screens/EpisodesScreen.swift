//
//  EpisodesScreen.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 26/09/2023.
//

import SwiftUI

struct EpisodesScreen: View {
    
    // MARK: - Properties
    @ObservedObject private var vm: EpisodesViewModel
    @State private var isShowingBottomSheet: Bool = false
    
    var podcast: Podcast?
    
    // MARK: - Initializers
    init(podcast: Podcast) {
        self.podcast = podcast
        self.vm = .init(podcast: podcast)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // TODO: List of Episodes
            ScrollView() {
                ForEach(vm.episodes) { episode in
                    EpisodeCellView(episode: episode)
                        .onTapGesture {
                            vm.episode = episode
                            isShowingBottomSheet = true
                        }
                }//: Loop
            } //: Scroll
            .navigationTitle(podcast?.trackName ?? "")
            
            // TODO: Show Episode Detail View
            EpisodeDetailView(vm: EpisodeDetailViewModel(episode: vm.episode), isShowing: $isShowingBottomSheet)
            
            if vm.isLoading {
                ProgressView()
                    .scaleEffect(2.0)
            }
        } //: ZStack
    }
}

// MARK: - Preview
struct EpisodesScreen_Previews: PreviewProvider {
    static var previews: some View {
//        EpisodesScreen()
        PodcastSearchScreen()
    }
}
