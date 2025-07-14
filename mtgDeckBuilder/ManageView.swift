//
//  ManageView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/16/25.
//

import SwiftUI
import Observation

@Observable
class Deck {
    var cards: [Card] = []
}

struct ManageView: View {
    @State private var query = ""
    @State private var decks = Array(1...20)
    
    func delItem(at offset: IndexSet) {
        decks.remove(atOffsets: offset)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        TextField("Search decks", text: $query)
                    }
                    Section("Decks") {
                        ForEach(decks, id: \.self) { deck in
                            Text("Deck \(deck)")
                        }
                        .onDelete(perform: delItem)
                    }
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    HStack {
                        Spacer()
                        Button() {
                            // Action
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
            .navigationTitle("Decks")
            .toolbar {
                EditButton()
            }
        }
    }
}

#Preview {
    ManageView()
}
