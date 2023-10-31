//
//  EpisodeDetailViewModel.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 30/09/2023.
//

import SwiftUI
import AVKit
import MediaPlayer

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
            setupAudioSession()
            playEpisode()
            observePlayerStartTime()
            observePlayerCurrentTime()
            setupNowPlayingInfo()
        }
    }
    
    let player = AVPlayer()
    var playListEpisodes: [Episode] = []
    
    // MARK: - Initializers
    init() {
        remoteControl()
        setupInterruptionObservers()
    }
    
    // MARK: - Functions
    fileprivate func setupInterruptionObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption), name: AVAudioSession.interruptionNotification, object: nil)
    }
    
    fileprivate func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let sessionError {
            print(sessionError)
        }
    }
    
    fileprivate func setupNowPlayingInfo() {
        var nowPlayingInfo: [String: Any] = [:]
        nowPlayingInfo[MPMediaItemPropertyTitle] = episode?.title
        nowPlayingInfo[MPMediaItemPropertyArtist] = episode?.author
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func remoteControl() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { _ in
            self.player.play()
            self.isPlaying = true
            self.scaleImageToLarge()
            self.setupElapsedTime()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { _ in
            self.player.pause()
            self.isPlaying = false
            self.scaleImageToSmall()
            self.setupElapsedTime()
            return .success
        }
        
        // using airpods touch or handfree button
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { _ in
            self.handlePlayPauseButton()
            return .success
        }
        
        commandCenter.nextTrackCommand.addTarget { _ in
            if self.playListEpisodes.count != 0 {
                let currentIndex = self.playListEpisodes.firstIndex { ep in
                    ep.title == self.episode?.title && ep.author == self.episode?.author
                }
                if let index = currentIndex {
                    if index == self.playListEpisodes.count - 1 {
                        self.episode = self.playListEpisodes[0]
                    } else {
                        self.episode = self.playListEpisodes[index + 1]
                    }
                }
            }
            return .success
        }
        
        commandCenter.previousTrackCommand.addTarget{ _ in
            if self.playListEpisodes.count != 0 {
                let currentIndex = self.playListEpisodes.firstIndex { ep in
                    ep.title == self.episode?.title && ep.author == self.episode?.author
                }
                if let index = currentIndex {
                    if index == 0 {
                        self.episode = self.playListEpisodes[self.playListEpisodes.count - 1]
                    } else {
                        self.episode = self.playListEpisodes[index - 1]
                    }
                }
            }
            return .success
        }
    }
    
    fileprivate func setupElapsedTime() {
        let elapsedTime = CMTimeGetSeconds(player.currentTime())
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = elapsedTime
    }
    
    fileprivate func setupLockScreenDuration() {
        guard let duration = player.currentItem?.duration else {return}
        let durationInSeconds = CMTimeGetSeconds(duration)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPMediaItemPropertyPlaybackDuration] = durationInSeconds
    }
    
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
            self?.setupLockScreenDuration()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        let seconds = CMTimeGetSeconds(player.currentTime())
        let totalSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        self.playerSlider = Float(seconds / totalSeconds)
    }
    
    func handlePlayPauseButton() {
        setupElapsedTime()
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
    
    // MARK: - @Objc
    @objc fileprivate func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let type = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt else { return }
        if type == AVAudioSession.InterruptionType.began.rawValue {
            isPlaying = false
            scaleImageToSmall()
        } else {
            guard let options = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt else {return}
            if options == AVAudioSession.InterruptionOptions.shouldResume.rawValue {
                player.play()
                isPlaying = true
                scaleImageToLarge()
            }
        }
    }
    
}
