//
//  CountrySearchView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import SwiftUI

struct CountrySearchView: View {
    @EnvironmentObject var container: DIContainer
    @Environment(\.dismiss) private var dismiss
    
    let onCountrySelected: (Country) -> Void
    let selectedCountries: [Country]
    
    init(onCountrySelected: @escaping (Country) -> Void, selectedCountries: [Country] = []) {
        self.onCountrySelected = onCountrySelected
        self.selectedCountries = selectedCountries
    }

    var body: some View {
        CountrySearchContentView(
            container: container,
            onCountrySelected: onCountrySelected,
            selectedCountries: selectedCountries,
            dismiss: dismiss
        )
    }
}


struct CountrySearchContentView: View {
    // MARK: - Properties
    let container: DIContainer
    let onCountrySelected: (Country) -> Void
    let selectedCountries: [Country]
    let dismiss: DismissAction
    @StateObject private var viewModel: CountrySearchViewModel
    
    
    init(container: DIContainer, onCountrySelected: @escaping (Country) -> Void, selectedCountries: [Country], dismiss: DismissAction) {
        self.container = container
        self.onCountrySelected = onCountrySelected
        self.selectedCountries = selectedCountries
        self.dismiss = dismiss
        self._viewModel = StateObject(wrappedValue: CountrySearchViewModel(
            countryUseCase: container.countryUseCase
        ))
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
                            isAlreadyAdded: selectedCountries.contains(country)
                        ) {
                            onCountrySelected(country)
                            dismiss()
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search Country")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search countries..."
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
