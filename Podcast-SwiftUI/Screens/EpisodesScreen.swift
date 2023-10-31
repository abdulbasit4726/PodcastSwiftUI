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
    @EnvironmentObject var vmMainTabBar: MainTabBarScreenViewModel
    @EnvironmentObject var vmPlayerDetail: EpisodeDetailViewModel
    
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
                                vmPlayerDetail.episode = episode
                                vmPlayerDetail.playListEpisodes = vm.episodes
                                vmMainTabBar.isMiniPlayer = false
                            }
                    }//: Loop
                    .padding(.bottom, 60)
                } //: Scroll
                
                if vm.isLoading {
                    ProgressView()
                        .scaleEffect(2.0)
                }
                
            } //: ZStack
            .navigationTitle(podcast?.trackName ?? "")
            .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview
struct EpisodesScreen_Previews: PreviewProvider {
    static var previews: some View {
//        EpisodesScreen()
        PodcastSearchScreen()
    }
}
