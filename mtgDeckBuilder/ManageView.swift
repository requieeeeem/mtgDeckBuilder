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
            ZStack(alignment: .bottom) {
                Form {
                    TextField("Search decks", text: $query)
                    Section("Decklists") {
                        List(decks, id: \.self) { deck in
                            Text("Deck \(deck)")
                        }
                    }
                }

                HStack {
                    Button("Add Deck") {
                        // Action
                    }
                    .frame(maxWidth: .infinity)

                    Button("Import Deck") {
                        // Action
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
            .navigationTitle("Decks")
        }
    }
}

#Preview {
    ManageView()
}
