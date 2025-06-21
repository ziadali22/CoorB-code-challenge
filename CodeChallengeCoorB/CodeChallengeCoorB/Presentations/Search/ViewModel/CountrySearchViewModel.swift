//
//  CountrySearchViewModel.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import Foundation
import Combine

@MainActor
final class CountrySearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchResults: [Country] = []
    @Published var isLoading = false
    @Published var selectedCountries: [Country] = []
    @Published var errorMessage: String?

    private let countryUseCase: CountryUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?
    private let maxCountries = 5

    init(countryUseCase: CountryUseCaseProtocol) {
        self.countryUseCase = countryUseCase
        bindSearchQuery()
    }

    private func bindSearchQuery() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                self?.performSearch(query: query)
            }
            .store(in: &cancellables)
    }

    private func performSearch(query: String) {
        searchTask?.cancel()

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchResults = []
            return
        }

        searchTask = Task {
            do {
                isLoading = true
                let countries = try await countryUseCase.searchCountry(by: query)
                searchResults = countries
            } catch {
                print("Failed to search countries: \(error)")
                searchResults = []
            }
            isLoading = false
        }
    }
    
    func clearSearch() {
        searchTask?.cancel()
        searchQuery = ""
        searchResults = []
        isLoading = false
        errorMessage = nil
    }
    
    deinit {
        searchTask?.cancel()
    }
    
}
