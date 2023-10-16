//
//  MainTabBarScreenViewModel.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 05/10/2023.
//

import SwiftUI

class MainTabBarScreenViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var playerViewOffset: CGFloat = UIScreen.main.bounds.height
    @Published var episode: Episode?
    @Published var playerViewHeight: CGFloat?
    @Published var isMiniPlayer: Bool = false {
        didSet {
            handlePlayerOffset()
        }
    }
    @Published var geomerty: GeometryProxy? {
        didSet {
            playerViewHeight = geomerty?.size.height
        }
    }
    
    private var miniPlayerHeight: CGFloat = 64
    private var tabBarHeight: CGFloat = Helpers.shared.getTabBarHeight()
    
    // MARK: - Functions
    func handlePlayerOffset() {
        if let geomerty {
            withAnimation(.spring(dampingFraction: 0.7)) {
                if isMiniPlayer {
                    playerViewOffset = geomerty.size.height - tabBarHeight - miniPlayerHeight
                    playerViewHeight = miniPlayerHeight
                } else {
                    playerViewOffset = 0
                    playerViewHeight = geomerty.size.height
                }
            }
        }
    }
}
