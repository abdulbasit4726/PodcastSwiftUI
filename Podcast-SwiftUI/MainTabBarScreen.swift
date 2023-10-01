//
//  ContentView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import SwiftUI

struct MainTabBarScreen: View {
    
    // MARK: - Body
    var body: some View {
        TabView {
            FavoritesScreen()
                .tabItem {
                    Label("Favorites", systemImage: "play.circle.fill")
                }
            PodcastSearchScreen()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            DownloadsScreen()
                .tabItem {
                    Label("Downloads", systemImage: "square.stack.fill")
                }
        } //: Tab
        .tint(.purple)
    }
}

struct MainTabBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarScreen()
    }
}
