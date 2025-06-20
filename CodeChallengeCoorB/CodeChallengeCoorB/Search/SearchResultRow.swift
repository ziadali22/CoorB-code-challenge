//
//  SearchResultRow.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct SearchResultRow: View {
    let isAdded: Bool
    let canAdd: Bool
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Egypt")
                    .font(.headline)
                
                Text("Capital: Cairo")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Currency: EGP")
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
