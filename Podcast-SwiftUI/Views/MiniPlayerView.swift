//
//  MiniPlayerView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 15/10/2023.
//

import SwiftUI

struct MiniPlayerView: View {
    
    // MARK: - Properties
    @EnvironmentObject var vm: EpisodeDetailViewModel
    
    // MARK: - Body
    var body: some View {
        HStack {
            if vm.episodeImage != nil {
                vm.episodeImage?
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(5)
                    .frame(width: 48, height: 48)
            } else {
                ProgressView()
                    .frame(width: 48, height: 48)
            }
            
            Text(vm.episode?.title ?? "")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.label))
                .lineLimit(1)
            
            Button {
                vm.handlePlayPauseButton()
            } label: {
                Image(vm.isPlaying ? "pause" : "play")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36, alignment: .center)
            }
            
            Button {
                vm.handleFastForward()
            } label: {
                Image("fastforward15")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36, alignment: .center)
            }
        }//: HStack
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

// MARK: - Preview
struct MiniPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        MiniPlayerView()
    }
}
