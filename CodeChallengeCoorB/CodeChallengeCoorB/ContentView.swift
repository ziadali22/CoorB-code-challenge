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
            VStack(spacing: 20) {
                Image(systemName: "globe")
                    .font(.system(size: 80))
                    .foregroundColor(.gray)
                
                Text("No countries added yet")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text("Tap the + add country \n button to search and add countries")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Countries List")
            .navigationBarItems(trailing: addCountryButton())
        }
    }
    
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

#Preview {
    HomeView()
}
