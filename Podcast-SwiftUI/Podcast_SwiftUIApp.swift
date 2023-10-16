//
//  Podcast_SwiftUIApp.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import SwiftUI

@main
struct Podcast_SwiftUIApp: App {
    
    @StateObject private var vm = MainTabBarScreenViewModel()
    @StateObject private var vmPlayerDetail = EpisodeDetailViewModel.shared
    
    var body: some Scene {
        WindowGroup {
            MainTabBarScreen()
                .environmentObject(vm)
                .environmentObject(vmPlayerDetail)
        }
    }
}
