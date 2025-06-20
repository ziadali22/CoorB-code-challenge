//
//  CountrySearchView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct CountrySearchView: View {
    @StateObject private var viewModel: CountrySearchViewModel

    init(countryUseCase: CountryUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: CountrySearchViewModel(useCase: countryUseCase))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.searchResults) { country in
                        SearchResultRow(
                            country: country,
                            isAdded: false,
                            canAdd: true
                        ) {
                            // save logic here
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search Country")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Enter country name")
        }
    }
}
