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
            miniPlayerOffset = (geomerty?.size.height ?? 0) - tabBarHeight - miniPlayerHeight
        }
    }
    
    private var miniPlayerHeight: CGFloat = 64
    private var tabBarHeight: CGFloat = Helpers.shared.getTabBarHeight()
    private var miniPlayerOffset: CGFloat?
    
    // MARK: - Functions
    func handlePlayerOffset() {
        if let geomerty {
            withAnimation(.spring(dampingFraction: 0.7)) {
                if isMiniPlayer {
                    playerViewOffset = miniPlayerOffset ?? 0
                    playerViewHeight = miniPlayerHeight
                } else {
                    playerViewOffset = 0
                    playerViewHeight = geomerty.size.height
                }
            }
        }
    }
    
    func handleDragChange(gesture: DragGesture.Value) {
        print(gesture.translation.height)
        if playerViewOffset >= 0 && !isMiniPlayer {
            playerViewOffset = gesture.translation.height
        } else if isMiniPlayer {
            if gesture.translation.height <= -50 {
                isMiniPlayer = false
                return
            }
            playerViewOffset = gesture.translation.height + (miniPlayerOffset ?? 0)
        }
    }
    
    func handleDragEnd(gesture: DragGesture.Value) {
        if !isMiniPlayer && gesture.translation.height > 100 {
            isMiniPlayer = true
        } else if isMiniPlayer && gesture.translation.height < -100 {
            isMiniPlayer = false
        } else {
            handlePlayerOffset()
        }
    }
}
