//
//  CountrySearchView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct CountrySearchView: View {
    @State var searchQuery: String = ""
    var body: some View {
        NavigationView {
            VStack {
                List() {
                    SearchResultRow(isAdded: true, canAdd: true) {
                        //save the result
                    }
                }
            }
        }
        .searchable(text: $searchQuery)
        .navigationTitle("Search Country")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CountrySearchView()
}
