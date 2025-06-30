//
//  HomeView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/12/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        TabView {
            ManageView()
                .tabItem {
                    Label("Decks", systemImage: "square.stack")
                }
            SearchView()
                .tabItem {
                    Label("Card Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    HomeView()
}
