//
//  CountryCardView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

struct CountriesListView: View {
    let countries: [Country]
    let onRemove: (Country) -> Void
    @State private var selectedCountry: Country?
    
    var body: some View {
        List(countries) { country in
            CountryCardView(country: country, onRemove: onRemove)
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedCountry = country
                }
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .sheet(item: $selectedCountry) { country in
            CountryDetailsView(country: country)
        }
    }
}

struct CountryCardView: View {
    let country: Country
    let onRemove: ((Country) -> Void)?
    
    init(country: Country, onRemove: @escaping (Country) -> Void) {
        self.country = country
        self.onRemove = onRemove
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                setHeaderTitleSection(countryName: country.name)
                
                Spacer()
                
                if let onRemove = onRemove {
                    Button(action: {
                        onRemove(country)
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .font(.title2)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            setCountryDetailsView(capital: country.displayCapital, currency: country.displayCurrencyCode)
        }
        .padding(16)
        .background(customCardBackground)
    }
    
    // MARK: - Sub Views
    private func setHeaderTitleSection(countryName: String) -> some View {
        Text(countryName)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundStyle(.primary)
            .lineLimit(1)
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
                            colors: [.black.opacity(0.3), .purple.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}
