//
//  AddDeck.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 7/14/25.
//

import SwiftUI
import SwiftData

struct AddDeck: View {
    /// for environmental stuff
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    /// If non-nil, we're editing this deck. Otherwise we're creating a new deck.
    let existingDeck: Deck?
    
    ///  belong to the current Deck
    @State private var name: String
    @State private var cards: [Card]
    
    /// for general card search purpose
    @State private var query = ""
    @State private var fetchedCard: Card? = nil
    @State private var errorMessage: String? = nil

    private var isEditing: Bool { existingDeck != nil }

    init(existingDeck: Deck? = nil) {
        self.existingDeck = existingDeck
        _name = State(initialValue: existingDeck?.name ?? "Deck Name")
        _cards = State(initialValue: existingDeck?.cards ?? [])
    }

    private func removeCard(at offsets: IndexSet) {
        cards.remove(atOffsets: offsets)
    }

    private func fetchCard(named name: String) async {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)") else {
            errorMessage = "Invalid card name"
            return
        }

        errorMessage = nil
        fetchedCard = nil

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode(Card.self, from: data)
            fetchedCard = decoded
        } catch {
            errorMessage = "Card not found or API error"
        }
    }

    private func addCard(_ card: Card) { cards.append(card) }

    private func save() {
        if let deck = existingDeck {
            // Edit mode: update the existing object
            deck.name = name
            deck.cards = cards
        } else {
            // Create mode: insert a brand new Deck
            let newDeck = Deck(name: name, cards: cards)
            modelContext.insert(newDeck)
        }
        // SwiftData auto-saves, but it's fine to try an explicit save.
        try? modelContext.save()
        dismiss()
    }

    var body: some View {
        Form {
            Section(header: Text("Add card")) {
                HStack(spacing: 12) {
                    TextField("Enter card name", text: $query)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                    Button("Add") {
                        Task {
                            await fetchCard(named: query)
                            if let c = fetchedCard {
                                addCard(c)
                                query.removeAll()
                            } else {
                                errorMessage = "No card loaded to add"
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                if let errorMessage { Text(errorMessage).foregroundStyle(.red) }
            }

            Section(header: Text("Cards (\(cards.count))")) {
                ForEach(cards, id: \.name) { card in
                    HStack(alignment: .center, spacing: 12) {
                        if let urlString = card.imageURIs?.artCrop, let url = URL(string: urlString) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .frame(width: 50, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .clipped()
                                case .failure:
                                    Image(systemName: "photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 70)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                @unknown default:
                                    EmptyView()
                                }
                            }
                        }
                        Text(card.name)
                    }
                }
                .onDelete(perform: removeCard)
            }
        }
        .navigationTitle($name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Update" : "Save", action: save)
            }
        }
    }
}

#Preview {
    AddDeck(existingDeck: nil)
}
