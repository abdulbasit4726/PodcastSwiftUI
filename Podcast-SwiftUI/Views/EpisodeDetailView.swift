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
    @ObservedObject var vm: EpisodeDetailViewModel
    @Binding var isShowing: Bool
    
    // MARK: - Body
    var body: some View {
        if isShowing {
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    // TODO: Dismiss Button
                    Button {
                        isShowing = false
                    } label: {
                        Text("Dismiss")
                            .foregroundColor(Color(.label))
                            .font(.system(size: 18, weight: .semibold))
                    } //: Button
                    
                    // TODO: Episode Image
                    AsyncImage(url: URL(string: vm.episode?.imageUrl ?? "")) {image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .padding(.vertical)
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                    } //: Image
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
                .position(x: geometry.frame(in: .local).midX, y: geometry.frame(in: .local).midY)
            } //: Geometry
            .edgesIgnoringSafeArea(.bottom)
            .background(Color.white)
            .toolbar(.hidden, for: .navigationBar, .tabBar)
            .onDisappear {
                vm.player.replaceCurrentItem(with: nil)
            }
        } //: If condition
    } //: Body
}

// MARK: - Preview
struct EpisodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeDetailView(vm: EpisodeDetailViewModel(episode: nil), isShowing: .constant(true))
            .previewLayout(.sizeThatFits)
    }
}
