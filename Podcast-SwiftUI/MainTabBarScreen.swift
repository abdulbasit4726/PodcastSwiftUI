//
//  ContentView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//
//


import SwiftUI

struct MainTabBarScreen: View {
    
    // MARK: - Properties
    @EnvironmentObject var vm: MainTabBarScreenViewModel
    
    // MARK: - Body
    var body: some View {
        ZStack {
            GeometryReader { geometry in
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
                .onAppear {
                    vm.geomerty = geometry
                }
                
                EpisodeDetailView()
                    .frame(height: vm.playerViewHeight)
                    .offset(y: vm.playerViewOffset)
                    .gesture(
                        DragGesture()
                            .onChanged({ gesture in
                                vm.handleDragChange(gesture: gesture)
                            })
                            .onEnded({ gesture in
                                vm.handleDragEnd(gesture: gesture)
                            })
                    ) //: Gesture
            } //: Geometry
        } //: ZStack
    }
}

struct MainTabBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarScreen()
    }
}
