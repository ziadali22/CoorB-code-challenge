//
//  CountryDetailsView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct CountryDetailsView: View {
    @Environment(\.dismiss) var dismiss
    let country: Country
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 24) {
                // Country Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(country.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                }
                
                // Capital City Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                        Text("Capital City")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(country.displayCapital)
                        .font(.title3.bold())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                // Currency Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        Text("Currency")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Text(country.displayCurrencyCode)
                        .font(.title3.bold())
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Country Details")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done", role: .destructive) {dismiss()})
        }
    }
}
