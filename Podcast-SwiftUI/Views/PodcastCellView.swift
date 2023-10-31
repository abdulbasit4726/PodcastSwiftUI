//
//  PodcastView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct PodcastCellView: View {
    
    // MARK: - Properties
    var podcast: Podcast?
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            HStack(spacing: 16) {
                WebImage(url: URL(string: podcast?.artworkUrl600 ?? ""))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
                    
                VStack(alignment: .leading, spacing: 3) {
                    Text(podcast?.trackName ?? "")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                    Text(podcast?.artistName ?? "")
                        .font(.system(size: 15))
                        .foregroundColor(Color(.label))
                    Text( "\(podcast?.trackCount ?? 0) Episodes")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.darkGray))
                } //: VStack
            } //: HStack
            .padding(.horizontal)
            .padding(.bottom, 8)
            Divider()
        } //: VStack
    }
}

struct PodcastCellView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastCellView(podcast: Podcast(trackName: "Lets Build that app", artistName: "BrainVoong", artworkUrl600: nil, trackCount: 3, feedUrl: nil))
            .previewLayout(.sizeThatFits)
    }
}
