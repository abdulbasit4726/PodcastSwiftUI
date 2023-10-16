//
//  EpisodeDetailViewModel.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 30/09/2023.
//

import SwiftUI
import AVKit

class EpisodeDetailViewModel: ObservableObject {
    // MARK: - Properties
    static let shared = EpisodeDetailViewModel()
    
    @Published var playerSlider: Float = 0
    @Published var volumeSlider: Float = 1
    @Published var imageScaleEffect = 0.7
    @Published var isPlaying: Bool = false
    @Published var currentTime: String = "--:--:--"
    @Published var totalTime: String = "--:--:--"
    @Published var episodeImage: Image?
    @Published var episode: Episode? {
        didSet {
            self.episodeImage = nil
            self.player.replaceCurrentItem(with: nil)
            playEpisode()
            observePlayerStartTime()
            observePlayerCurrentTime()
        }
    }
    
    let player = AVPlayer()
    
    // MARK: - Initializers
    
    // MARK: - Functions
    fileprivate func playEpisode() {
        print("playing")
        guard let url = URL(string: episode?.streamUrl ?? "") else {return}
        let playerItem = AVPlayerItem(url: url)
        self.player.replaceCurrentItem(with: playerItem)
        self.player.play()
        self.isPlaying = true
    }
    
    fileprivate func observePlayerCurrentTime() {
        let interval = CMTimeMake(value: 1,timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            self?.currentTime = time.formatTimeString()
            self?.totalTime = self?.player.currentItem?.duration.formatTimeString() ?? "--:--:--"
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func observePlayerStartTime() {
        let time = CMTimeMake(value: 1, timescale: 1)
        player.addBoundaryTimeObserver(forTimes: [NSValue(time: time)], queue: .main) { [weak self] in
            self?.scaleImageToLarge()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let seconds = CMTimeGetSeconds(player.currentTime())
        let totalSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        self.playerSlider = Float(seconds / totalSeconds)
    }
    
    func handlePlayPauseButton() {
        if player.timeControlStatus != .paused {
            player.pause()
            isPlaying = false
            scaleImageToSmall()
        } else {
            player.play()
            isPlaying = true
            scaleImageToLarge()
        }
    }
    
    func handlePlaySlider() {
        let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTime.zero)
        let seekTime = CMTimeMakeWithSeconds(Double(playerSlider) * duration, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    func handleFastForward() {
        seekToTime(delta: 15)
    }
    
    func handleRewind() {
        seekToTime(delta: -15)
    }
    
    fileprivate func seekToTime(delta: Int64) {
        let seconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), seconds)
        player.seek(to: seekTime)
    }
    
    fileprivate func scaleImageToLarge() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
            imageScaleEffect = 1
        }
    }
    
    fileprivate func scaleImageToSmall() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
            imageScaleEffect = 0.7
        }
    }
}
