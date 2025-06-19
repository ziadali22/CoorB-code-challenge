//
//  CountryCardView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

struct CountryCardView: View {
    let onTap: () -> Void
    let onRemove: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                setHeaderTitleSection(countryName: "United Arab Emirates")
                Spacer()
                removeButtonView
            }

            setCountryDetailsView(capital: "Dubai", currency: "AED")
        }
        .padding(16)
        .background {customCardBackground}
        .onTapGesture {handleTapGesture()}
    }
    
    // MARK: - Sub Views
    private func setHeaderTitleSection(countryName: String) -> some View {
        Text(countryName)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .lineLimit(1)
    }
    private var removeButtonView: some View {
        Button(action: onRemove) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .buttonStyle(PlainButtonStyle())
        }
        .padding(8)
    }
    
    private func setCountryDetailsView(capital: String, currency: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            CapitalAndCurrencyView(
                icon: "building.2.fill",
                iconColor: .blue,
                title: "Capital",
                value: capital
            )
            
            CapitalAndCurrencyView(
                icon: "dollarsign.circle.fill",
                iconColor: .green,
                title: "Currency",
                value: currency
            )
        }
    }
    
    private var customCardBackground: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
    // MARK: - Actions
    private func handleTapGesture() {
        onTap()
    }
}
