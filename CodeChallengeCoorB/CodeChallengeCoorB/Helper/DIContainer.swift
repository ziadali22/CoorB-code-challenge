//
//  DIContainer.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import Foundation
class DIContainer: ObservableObject {
    // Services
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var cacheService: CacheServiceProtocol = CacheService()
    
    // Repository
    lazy var countryRepository: CountryRepositoryProtocol = CountryRepository(
        networkService: networkService
    )
    
    // Use Cases
    lazy var countryUseCase: CountryUseCaseProtocol = CountryUseCase(
        repository: countryRepository
    )
}
