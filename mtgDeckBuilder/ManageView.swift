//
//  ManageView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/16/25.
//

import SwiftUI
import SwiftData


struct ManageView: View {
    @Environment(\.modelContext) var modelContext
    @Query var decks: [Deck]
    
    @State private var path = NavigationPath()
    @State private var query = ""
//    @State private var showAddDeck = false
    
    func delItem(at offsets: IndexSet) {
        for offset in offsets {
            let deck = decks[offset]
            modelContext.delete(deck)
        }
    }
    
    var filterDecks: [Deck] {
        guard !query.isEmpty else { return decks }
        return decks.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    ForEach(filterDecks) { deck in
                        NavigationLink(value: deck) {
                            VStack(alignment: .leading) {
                                Text(deck.name)
                                    .font(.headline)
                                Text("Cards: \(deck.cardCount)/100")
                            }
                        }
                    }
                    .onDelete(perform: delItem)
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    HStack {
                        Spacer()
                        NavigationLink {
                            AddDeck(existingDeck: nil)
                        } label: {
                            Image(systemName: "plus")
                                .symbolVariant(.circle.fill)
                                .font(.system(size: 54, weight: .bold, design: .rounded))
                        }
                        .padding(.trailing)
                    }
                    .padding()
                    
                }
            }
            .navigationTitle("Commander Decks")
            .toolbar {
                EditButton()
            }
            .searchable(text: $query, prompt: "Search your deck")
//            .navigationDestination(isPresented: $showAddDeck) {
//                AddDeck(existingDeck: nil)
//            }
            .navigationDestination(for: Deck.self) { deck in
                AddDeck(existingDeck: deck)
            }
        }
    }
}

#Preview {
    ManageView()
}
