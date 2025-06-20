//
//  SearchResultRow.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct SearchResultRow: View {
    let country: Country
    let isAdded: Bool
    let canAdd: Bool
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(country.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text("Capital: \(country.displayCapital)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Currency: \(country.displayCurrencyCode)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isAdded {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            } else {
                Button(action: onAdd) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(canAdd ? .blue : .gray)
                        .font(.title3)
                }
                .disabled(!canAdd)
            }
        }
        .padding(.vertical, 4)
    }
}
