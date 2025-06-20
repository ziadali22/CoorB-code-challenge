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

    private let useCase: CountryUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private var searchTask: Task<Void, Never>?

    init(useCase: CountryUseCaseProtocol) {
        self.useCase = useCase
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
                let countries = try await useCase.searchCountry(by: query)
                searchResults = countries
            } catch {
                print("Failed to search countries: \(error)")
                searchResults = []
            }
            isLoading = false
        }
    }
}
