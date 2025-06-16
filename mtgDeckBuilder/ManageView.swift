//
//  ManageView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/16/25.
//

import SwiftUI

struct ManageView: View {
    @State private var query = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Search decks", text: $query)
                Section("Decklists") {
                    HStack {
                        Button("Add Deck") {
                            
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                        Button("Import Deck") {
                            
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                    .frame(alignment: .bottom)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }.navigationTitle("Decks")
        }
    }
}

#Preview {
    ManageView()
}
