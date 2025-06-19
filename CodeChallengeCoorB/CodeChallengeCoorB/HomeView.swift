//
//  ContentView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            EmptyView()
            .navigationTitle("Countries List")
            .navigationBarItems(trailing: addCountryButton())
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
           print("Add country button Tapped")
        } label: {
            Image(systemName: "plus.circle")
                .foregroundStyle(.green)
            Text("Add country")
                .foregroundStyle(.green)
        }
    }
}
