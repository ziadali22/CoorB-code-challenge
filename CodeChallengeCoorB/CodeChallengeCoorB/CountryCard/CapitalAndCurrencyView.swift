//
//  CapitalAndCurrencyView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct CapitalAndCurrencyView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 8) {
            // Icon with background
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 22, height: 22)
                
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(iconColor)
            }
            
            HStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                
                Text(value)
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
            }
            Spacer()
        }
    }
}

#Preview {
    CapitalAndCurrencyView(icon: "flag",
                           iconColor: .blue,
                           title: "Capital",
                           value: "Abuja")
}
