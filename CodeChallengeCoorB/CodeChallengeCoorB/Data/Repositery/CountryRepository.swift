//
//  CountryRepository.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//


protocol CountryRepositoryProtocol {
    func fetchCountryByName(_ name: String) async throws -> [Country]
}

class CountryRepository: CountryRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCountryByName(_ name: String) async throws -> [Country] {
        return try await networkService.fetchCountries(by: name)
    }
}
