//
//  ContentView.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var container: DIContainer
    @State private var showingSearch = false
    
    var body: some View {
        HomeContentView(container: container, showingSearch: $showingSearch)
    }
}

struct HomeContentView: View {
    let container: DIContainer
    @Binding var showingSearch: Bool
    @StateObject private var viewModel: HomeViewModel
    
    init(container: DIContainer, showingSearch: Binding<Bool>) {
        self.container = container
        self._showingSearch = showingSearch
        self._viewModel = StateObject(wrappedValue: HomeViewModel(cacheService: container.cacheService,
                                                                  countryUseCase: container.countryUseCase,
                                                                  locationManager: container.locationManager
           
        ))
    }
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isInitializing {
                    VStack {
                        ProgressView("Loading countries...")
                        Text("Setting up your location-based country")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                } else if viewModel.selectedCountries.isEmpty {
                    EmptyView()
                } else {
                    CountriesListView(
                        countries: viewModel.selectedCountries,
                        onRemove: viewModel.removeCountry
                    )
                }
            }
            .navigationTitle("My Countries")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Country") {
                        showingSearch = true
                    }
                    .disabled(!viewModel.canAddMoreCountries)
                }
            }
            .sheet(isPresented: $showingSearch) {
                CountrySearchView(
                    onCountrySelected: { country in
                        viewModel.addCountry(country)
                    },
                    selectedCountries: viewModel.selectedCountries
                )
                .environmentObject(container)
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
