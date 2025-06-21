//
//  CountryUseCase.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

protocol CountryUseCaseProtocol {
    func searchCountry(by name: String) async throws -> [Country]
    func getCountry(by code: String) async throws -> Country?
}

class CountryUseCase: CountryUseCaseProtocol {
    private let repository: CountryRepositoryProtocol
    
    init(repository: CountryRepositoryProtocol) {
        self.repository = repository
    }
    
    func searchCountry(by name: String) async throws -> [Country] {
        return try await repository.fetchCountryByName(name)
    }
    
    func getCountry(by code: String) async throws -> Country? {
        return try await repository.fetchCountryByCode(code)
    }
}
