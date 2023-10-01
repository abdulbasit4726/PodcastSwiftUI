//
//  RSSFeed.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 26/09/2023.
//

import FeedKit

extension RSSFeed {
    func toEpisodes() -> [Episode] {
        var episodes: [Episode] = []
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        items?.forEach({ feedItem in
            var episode = Episode(feedItem: feedItem)
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            episodes.append(episode)
        })
        return episodes
    }
}

