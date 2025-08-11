//
//  CardDetailView.swift
//  mtgDeckBuilder
//
//  Created by Michael Luong on 7/29/25.
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    
    var body: some View {
        ScrollView {
            
            if let urlString = card.imageURIs?.artCrop,
               let url = URL(string: urlString)
            {
                AsyncImage(url: url) { image in
                    image
                        .scaledToFit()
                    
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading) {
                    Text(card.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    Text("Mana Cost: \(card.manaCost ?? "0")")
                        .font(.subheadline)
                    
                    Divider()
                    
                    Text("Type: \(card.typeLine ?? "None")")
                        .font(.subheadline)
                    
                    Divider()
                    
                    Text("Oracle Text: \(card.oracleText ?? "None")")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(width: 350)
                .padding()
            } else {
                Text("Card cannot be displayed.").foregroundStyle(.red)
            }
            
        }
        .toolbar(.hidden, for: .tabBar)
    }
}


