//
//  EpisodeDetailView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 26/09/2023.
//

import SwiftUI
import AVKit

struct EpisodeDetailView: View {
    // MARK: - Properties
    @EnvironmentObject var vm: EpisodeDetailViewModel
    @EnvironmentObject var vmMainTabBar: MainTabBarScreenViewModel

    // MARK: - Body
    var body: some View {
            GeometryReader { geometry in
                ZStack (alignment: .top){
                        VStack(alignment: .center) {
                            // TODO: Dismiss Button
                            Button {
                                withAnimation(.default){
                                    vmMainTabBar.isMiniPlayer = true
                                }
                            } label: {
                                Text("Dismiss")
                                    .foregroundColor(Color(.label))
                                    .font(.system(size: 18, weight: .semibold))
                            } //: Button
                            
                            // TODO: Episode Image
                            VStack{
                                if let image = vm.episodeImage {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .cornerRadius(10)
                                        .padding(.vertical)
                                } else {
                                    AsyncImage(url: URL(string: vm.episode?.imageUrl ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .cornerRadius(10)
                                            .padding(.vertical)
                                        let _ =  DispatchQueue.main.async {
                                            vm.episodeImage = image
                                        }
                                    } placeholder: {
                                        ProgressView()
                                            .scaleEffect(2.0)
                                    } //: Image
                                }
                            } //: VStack
                            .scaleEffect(vm.imageScaleEffect)
                            .frame(width: geometry.size.height * 0.35, height: geometry.size.height * 0.35, alignment: .center)
                            // TODO: Player Slider + Player Time
                            VStack{
                                Slider(value: $vm.playerSlider) { _ in
                                    vm.handlePlaySlider()
                                }
                                HStack {
                                    Text(vm.currentTime)
                                        .foregroundColor(.gray)
                                    Spacer()
                                    Text(vm.totalTime)
                                        .foregroundColor(.gray)
                                } //: HStack
                            } //: VStack
                            Spacer()
                            
                            // TODO: Episode Name + Author Name
                            VStack(spacing: 5) {
                                Text(vm.episode?.title ?? "")
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(Color(.label))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                Text(vm.episode?.author ?? "")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(Color.purple)
                                    .multilineTextAlignment(.center)
                            }
                            Spacer()
                            
                            // TODO: Play/Pause Button + Fast Forward and Rewind Button
                            HStack {
                                Spacer()
                                Button {
                                    vm.handleRewind()
                                } label: {
                                    Image("rewind15")
                                }
                                Spacer()
                                Button {
                                    vm.handlePlayPauseButton()
                                } label: {
                                    Image(vm.isPlaying ? "pause" : "play")
                                }
                                Spacer()
                                Button {
                                    vm.handleFastForward()
                                } label: {
                                    Image("fastforward15")
                                }
                                Spacer()
                            } //: HStack
                            Spacer()
                            
                            // TODO: Volume Slider
                            HStack(spacing: 5) {
                                Image("muted_volume")
                                Slider(value: $vm.volumeSlider) {_ in
                                    vm.player.volume = vm.volumeSlider
                                }
                                Image("max_volume")
                            } //: VStack
                        } //: VStack
                        .padding([.top, .leading, .trailing])
                        .padding(.bottom, 40)
                        .opacity(vmMainTabBar.isMiniPlayer ? 0 : 1)

                       MiniPlayerView()
                            .onTapGesture {
                                withAnimation(.default) {
                                    vmMainTabBar.isMiniPlayer = false
                                }
                            }
                            .opacity(vmMainTabBar.isMiniPlayer ? 1 : 0)
                } //: ZStack
                
            } //: Geometry
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.white)
    } //: Body
}

// MARK: - Preview
struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView()
            .previewLayout(.sizeThatFits)
    }
}
