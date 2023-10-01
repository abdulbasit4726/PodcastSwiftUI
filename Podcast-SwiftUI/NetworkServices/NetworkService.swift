//
//  NetworkService.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import Alamofire
import FeedKit

class NetworkService {
    static let shared = NetworkService()
    
    private let baseUrl = "https://itunes.apple.com/search?term="
    
    func fetchPodcasts(searchText: String, completion: @escaping ([Podcast]) -> ()) {
//        let url = baseUrl + searchText.replacingOccurrences(of: " ", with: "%2d")
        let parameters = ["term": searchText, "media": "podcast"]
        AF.request(baseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).response { dataResponse in
            if let error = dataResponse.error {
                print("Failed to contact requested search string: ", error)
                return
            }
            
            guard let data = dataResponse.data else {return}
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results)
            } catch let decodeError {
                print("Failed to decode:", decodeError)
            }
        }
    }
    
    func fetchEpisodes(feedUrl: String, completion: @escaping ([Episode]) -> ()) {
        guard let url = URL(string: feedUrl) else { return }
        FeedParser(URL: url).parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch(result) {
            case .success(let feed):
                switch(feed) {
                case .atom(_):
                    break
                case .rss(let feed):
                    completion(feed.toEpisodes())
                case .json(_):
                    break
                }
            case .failure(let error):
                print("Failed to fetch episodes:", error)
            }
        }
    }
}
