//
//  SearchResultRow.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct SearchResultRow: View {
    let country: Country
    let isAlreadyAdded: Bool
    let onTap: () -> Void
    
    init(country: Country, isAlreadyAdded: Bool, onTap: @escaping () -> Void) {
        self.country = country
        self.isAlreadyAdded = isAlreadyAdded
        self.onTap = onTap
    }
    
    var body: some View {
        Button(action: {
            if !isAlreadyAdded {
                onTap()
            }
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(country.name)
                        .font(.headline)
                        .foregroundColor(isAlreadyAdded ? .secondary : .primary)
                    
                    Text("Capital: \(country.displayCapital)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("Currency: \(country.displayCurrency)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                
                if isAlreadyAdded {
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        
                        Text("Added")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
            }
            .padding(.vertical, 4)
            .contentShape(Rectangle())
            .opacity(isAlreadyAdded ? 0.6 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isAlreadyAdded)
    }
}
