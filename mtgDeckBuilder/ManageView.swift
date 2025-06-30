//
//  ManageView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/16/25.
//

import SwiftUI

struct ManageView: View {
    @State private var query = ""
    @State private var decks = Array(1...20)
    
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
                    }
                }
                .safeAreaInset(edge: .bottom, alignment: .trailing) {
                    HStack {
                        Spacer()
                        VStack() {
                            Button("Add Deck") {
                                // Action
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                    
                }
                
                
            }
            .navigationTitle("Decks")
        }
    }
}

#Preview {
    ManageView()
}
