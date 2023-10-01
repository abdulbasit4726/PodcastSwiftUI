//
//  CMTime.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 28/09/2023.
//

import AVKit

extension CMTime {
    func formatTimeString() -> String {
        if CMTimeGetSeconds(self).isNaN {
            return "-- : --"
        }
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hours = totalSeconds / 60 / 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
