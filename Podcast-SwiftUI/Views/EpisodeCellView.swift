//
//  EpisodeCellView.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 26/09/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EpisodeCellView: View {
    // MARK: - Properties
    var episode: Episode?
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 16) {
                WebImage(url: URL(string: episode?.imageUrl ?? ""))
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(5)
                    
                VStack(alignment: .leading, spacing: 3) {
                    Text(episode?.pubDate.toStringFormat() ?? "")
                        .font(.system(size: 13))
                        .foregroundColor(Color.purple)
                    Text(episode?.title ?? "")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(.label))
                        .lineLimit(2)
                    Text(episode?.description ?? "")
                        .font(.system(size: 13))
                        .foregroundColor(Color(.darkGray))
                        .lineLimit(2)
                } //: VStack
            } //: HStack
            .padding(.horizontal)
            .padding(.bottom, 8)
            Divider()
        } //: VStack
    }
}

// MARK: - Preview
struct EpisodeCellView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodeCellView()
            .previewLayout(.sizeThatFits)
    }
}
