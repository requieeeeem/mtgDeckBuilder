//
//  SearchView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 6/12/25.
//

import SwiftUI

struct Card: Decodable {
    let name: String
    let image_uris: ImageURIs?
    
    struct ImageURIs: Decodable {
        let normal: String
    }
}
struct SearchView: View {
    let bigCircleRadius: CGFloat = 150
    let smallCircleRadius: CGFloat = 40
    let numberOfCircles = 5
    let dotColors = [
        Color(red: 248/255.0, green: 231/255.0, blue: 185/255.0),
        Color(red: 179/255.0, green: 206/255.0, blue: 234/255.0),
        Color(red: 166/255.0, green: 159/255.0, blue: 157/255.0),
        Color(red: 235/255.0, green: 159/255.0, blue: 130/255.0),
        Color(red: 196/255.0, green: 211/255.0, blue: 202/255.0)
    ]
    
    @State private var query: String = ""
    @State private var card: Card? = nil
    @State private var errorMessage: String? = nil
    
    func fetchCard(named name: String) {
        guard let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.scryfall.com/cards/named?fuzzy=\(encodedName)") else {
            errorMessage = "Invalid card name"
            return
        }

        errorMessage = nil
        card = nil
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decoded = try JSONDecoder().decode(Card.self, from: data)
                card = decoded
            } catch {
                errorMessage = "Card not found or API error"
            }
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                .frame(width: bigCircleRadius * 2, height: bigCircleRadius * 2)
            
            // Small circles on the circumference
            ForEach(0..<numberOfCircles, id: \.self) { i in
                let angle = 2 * .pi / CGFloat(numberOfCircles) * CGFloat(i) - .pi / 2
                let xOffset = cos(angle) * bigCircleRadius
                let yOffset = sin(angle) * bigCircleRadius
                let chosenColor = dotColors[i]
                
                Circle()
                    .fill(chosenColor)
                    .frame(width: smallCircleRadius * 2, height: smallCircleRadius * 2)
                    .offset(x: xOffset, y: yOffset)
            }
            VStack(spacing: 20) {
                Text("Card Search")
                    .font(.largeTitle)
                    .padding(.top)
                HStack {
                    TextField("Enter card name", text: $query)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button("Search") {
                        fetchCard(named: query)
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if let card = card {
                    if let urlString = card.image_uris?.normal,
                       let url = URL(string: urlString) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(card.name)
                        .font(.title2)
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    SearchView()
}
