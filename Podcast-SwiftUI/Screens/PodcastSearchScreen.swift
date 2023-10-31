//
//  PodcastSearchScreen.swift
//  Podcast-SwiftUI
//
//  Created by frizhub on 24/09/2023.
//

import SwiftUI

struct PodcastSearchScreen: View {
    
    // MARK: - Properties
    @State private var searchText: String = ""
    @StateObject private var vm = PodcastSearchViewModel()
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    ForEach(vm.podcasts) { podcast in
                        VStack {
                            NavigationLink {
                                EpisodesScreen(podcast: podcast)
                            } label: {
                                PodcastCellView(podcast: podcast)
                            } //: Navigation Link
                        } //: VStack
                    } //: Loop
                    .padding(.bottom, 60)
                } //: Scroll
                if vm.isLoading {
                    ProgressView()
                        .scaleEffect(2.0)
                } //: Condition
            } //: ZStack
            .navigationTitle("Search")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {                
                    self.vm.handleSearch(searchText: newValue)
                }
            }
        } //: Navigation
        
    }
}

// MARK: - Preview
struct PodcastSearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        PodcastSearchScreen()
    }
}
