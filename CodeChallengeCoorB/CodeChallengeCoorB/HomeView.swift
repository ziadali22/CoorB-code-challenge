//
//  ContentView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToSearch = false
    @State private var navigateToDetails = false
    
    var body: some View {
        NavigationStack {
            List(0..<5) {_ in 
                CountryCardView(onTap: {
                    navigateToDetails = true
                },onRemove: {})
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .navigationTitle("Countries List")
            .navigationBarItems(trailing: addCountryButton())
            .navigationDestination(isPresented: $navigateToSearch) {
                CountrySearchView()
            }
            .navigationDestination(isPresented: $navigateToDetails) {
               CountryDetailsView()
            }
        }
    }
}

#Preview {
    HomeView()
}

// MARK: - Helper Views
extension HomeView {
    // navigation bar trailling button
    func addCountryButton() -> some View {
        Button {
            navigateToSearch = true
        } label: {
            Image(systemName: "plus.circle")
                .foregroundStyle(.green)
            Text("Add country")
                .foregroundStyle(.green)
        }
    }
}
