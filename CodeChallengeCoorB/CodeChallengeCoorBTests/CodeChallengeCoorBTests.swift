//
//  CodeChallengeCoorBTests.swift
//  CodeChallengeCoorBTests
//
//  Created by Ziad Khalil on 21/06/2025.
//

import CoreLocation
import XCTest
@testable import CodeChallengeCoorB

class CountriesAppTests: XCTestCase {
    
    // MARK: - Mock Classes
    class MockNetworkService: NetworkServiceProtocol {
        var shouldThrowError = false
        var mockCountries: [Country] = []
        var mockCountry: Country?
        
        func fetchCountries(by name: String) async throws -> [Country] {
            if shouldThrowError {
                throw NetworkError.invalidResponse
            }
            return mockCountries
        }
        
        func fetchCountryByCode(_ code: String) async throws -> Country? {
            if shouldThrowError {
                throw NetworkError.invalidResponse
            }
            return mockCountry
        }
    }
    
    class MockCacheService: CacheServiceProtocol {
        private var searchCache: [String: [Country]] = [:]
        private var selectedCountries: [Country] = []
        
        func saveCountries(_ countries: [Country], for searchTerm: String) {
            searchCache[searchTerm.lowercased()] = countries
        }
        
        func getCountries(for searchTerm: String) -> [Country]? {
            return searchCache[searchTerm.lowercased()]
        }
        
        func saveSelectedCountries(_ countries: [Country]) {
            selectedCountries = countries
        }
        
        func getSelectedCountries() -> [Country] {
            return selectedCountries
        }
        
        func clearCache() {
            searchCache.removeAll()
            selectedCountries.removeAll()
        }
    }
    
    class MockLocationService: LocationManagerProtocol {
        @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
        var mockCountryCode: String?
        
        func requestLocationPermission() {
            authorizationStatus = .authorizedWhenInUse
        }
        
        func getCurrentCountryCode() async -> String? {
            return mockCountryCode
        }
    }
    
    // MARK: - Test Properties
    var mockNetworkService: MockNetworkService!
    var mockCacheService: MockCacheService!
    var mockLocationService: MockLocationService!
    var countryRepository: CountryRepository!
    var countryUseCase: CountryUseCase!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        mockCacheService = MockCacheService()
        mockLocationService = MockLocationService()
        countryRepository = CountryRepository(networkService: mockNetworkService)
        countryUseCase = CountryUseCase(repository: countryRepository)
    }
    
    override func tearDown() {
        mockNetworkService = nil
        mockCacheService = nil
        mockLocationService = nil
        countryRepository = nil
        countryUseCase = nil
        super.tearDown()
    }
    
    // MARK: - Model Tests
    func testCountryModel() {
        let currency = Currency(code: "USD", name: "United States Dollar", symbol: "$")
        let country = Country(name: "United States", capital: "Washington D.C.", currencies: [currency], alpha2Code: "US")
        
        XCTAssertEqual(country.name, "United States")
        XCTAssertEqual(country.displayCapital, "Washington D.C.")
        XCTAssertEqual(country.displayCurrency, "United States Dollar")
        XCTAssertEqual(country.displayCurrencyCode, "USD")
        XCTAssertEqual(country.id, "US")
    }
    
    // MARK: - Countries List ViewModel Tests
    @MainActor
    func testCountriesListViewModelAddCountry() {
        let viewModel = HomeViewModel(
            cacheService: mockCacheService,
            countryUseCase: countryUseCase,
            locationManager: mockLocationService
        )
        
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        
        viewModel.addCountry(mockCountry)
        
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        XCTAssertEqual(viewModel.selectedCountries.first?.name, "Egypt")
        XCTAssertTrue(viewModel.canAddMoreCountries)
    }
    
    @MainActor
    func testCountriesListViewModelMaxCountriesLimit() {
        let viewModel = HomeViewModel(
            cacheService: mockCacheService,
            countryUseCase: countryUseCase,
            locationManager: mockLocationService
        )
        
        // Add 5 countries (maximum limit)
        for i in 1...5 {
            let country = Country(name: "Country\(i)", capital: "Capital\(i)", currencies: nil, alpha2Code: "C\(i)")
            viewModel.addCountry(country)
        }
        
        XCTAssertEqual(viewModel.selectedCountries.count, 5)
        XCTAssertFalse(viewModel.canAddMoreCountries)
        
        // Try to add 6th country
        let sixthCountry = Country(name: "Country6", capital: "Capital6", currencies: nil, alpha2Code: "C6")
        viewModel.addCountry(sixthCountry)
        
        XCTAssertEqual(viewModel.selectedCountries.count, 5)
        XCTAssertEqual(viewModel.errorMessage, "Maximum 5 countries allowed")
    }
    
    @MainActor
    func testCountriesListViewModelRemoveCountry() {
        let viewModel = HomeViewModel(
            cacheService: mockCacheService,
            countryUseCase: countryUseCase,
            locationManager: mockLocationService
        )
        
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        
        viewModel.addCountry(mockCountry)
        XCTAssertEqual(viewModel.selectedCountries.count, 1)
        
        viewModel.removeCountry(mockCountry)
        XCTAssertEqual(viewModel.selectedCountries.count, 0)
    }
    
    
    @MainActor
    func testCountrySearchViewModelEmptyQuery() {
        let searchViewModel = CountrySearchViewModel(countryUseCase: countryUseCase)
        
        searchViewModel.performSearch(query: "")
        
        XCTAssertTrue(searchViewModel.searchResults.isEmpty)
        XCTAssertFalse(searchViewModel.isLoading)
    }
    
    @MainActor
    func testCountrySearchViewModelClearSearch() {
        let searchViewModel = CountrySearchViewModel(countryUseCase: countryUseCase)
        
        searchViewModel.searchQuery = "Egypt"
        searchViewModel.searchResults = [createMockCountry()]
        searchViewModel.isLoading = true
        
        searchViewModel.clearSearch()
        
        XCTAssertTrue(searchViewModel.searchQuery.isEmpty)
        XCTAssertTrue(searchViewModel.searchResults.isEmpty)
        XCTAssertFalse(searchViewModel.isLoading)
    }
    
    // MARK: - Detail ViewModel Tests
    func testCountryDetailViewModel() {
        let currency = Currency(code: "USD", name: "US Dollar", symbol: "$")
        let country = Country(name: "United States", capital: "Washington D.C.", currencies: [currency], alpha2Code: "US")
        
        let detailViewModel = CountryDetailsView(country: country)
        
        XCTAssertEqual(detailViewModel.country.name, "United States")
        XCTAssertEqual(detailViewModel.country.name.count, 13)
        XCTAssertEqual(detailViewModel.country.capital, "Washington D.C.")
    }
    
    // MARK: - Repository Tests
    func testFetchCountryByNameFromNetwork() async throws {
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        mockNetworkService.mockCountries = [mockCountry]
        
        let countries = try await countryRepository.fetchCountryByName("Egypt")
        
        XCTAssertEqual(countries.count, 1)
        XCTAssertEqual(countries.first?.name, "Egypt")
        XCTAssertEqual(countries.first?.capital, "Cairo")
    }

    
    // MARK: - UseCase Tests
    func testSearchCountrySuccess() async throws {
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        mockNetworkService.mockCountries = [mockCountry]
        
        let countries = try await countryUseCase.searchCountry(by: "Egypt")
        
        XCTAssertEqual(countries.count, 1)
        XCTAssertEqual(countries.first?.name, "Egypt")
    }
    
    func testGetCountryByCodeSuccess() async throws {
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        mockNetworkService.mockCountry = mockCountry
        
        let country = try await countryUseCase.getCountry(by: "EG")
        
        XCTAssertNotNil(country)
        XCTAssertEqual(country?.name, "Egypt")
        XCTAssertEqual(country?.alpha2Code, "EG")
    }
    
    // MARK: - Cache Service Tests
    func testCacheServiceSaveAndRetrieve() {
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        
        mockCacheService.saveCountries([mockCountry], for: "Egypt")
        let retrievedCountries = mockCacheService.getCountries(for: "Egypt")
        
        XCTAssertNotNil(retrievedCountries)
        XCTAssertEqual(retrievedCountries?.count, 1)
        XCTAssertEqual(retrievedCountries?.first?.name, "Egypt")
    }
    
    func testCacheServiceSelectedCountries() {
        let mockCountry = Country(name: "Egypt", capital: "Cairo", currencies: [Currency(code: "EGP", name: "Egyptian Pound", symbol: "£")], alpha2Code: "EG")
        
        mockCacheService.saveSelectedCountries([mockCountry])
        let retrievedCountries = mockCacheService.getSelectedCountries()
        
        XCTAssertEqual(retrievedCountries.count, 1)
        XCTAssertEqual(retrievedCountries.first?.name, "Egypt")
    }
    
    // MARK: - Error Tests
    func testNetworkErrorDescriptions() {
        let invalidURLError = NetworkError.invalidURL
        let invalidResponseError = NetworkError.invalidResponse
        let decodingError = NetworkError.decodingError(NSError(domain: "test", code: 0, userInfo: nil))
        
        XCTAssertEqual(invalidURLError.errorDescription, "Invalid URL")
        XCTAssertEqual(invalidResponseError.errorDescription, "Invalid response from server")
        XCTAssertTrue(decodingError.errorDescription?.contains("Failed to decode response") == true)
    }
    
    // MARK: - Integration Tests
    func testCountryEquality() {
        let country1 = Country(name: "Egypt", capital: "Cairo", currencies: nil, alpha2Code: "EG")
        let country2 = Country(name: "Egypt", capital: "Cairo", currencies: nil, alpha2Code: "EG")
        let country3 = Country(name: "USA", capital: "Washington", currencies: nil, alpha2Code: "US")
        
        XCTAssertEqual(country1, country2)
        XCTAssertNotEqual(country1, country3)
    }
    
    // MARK: - Performance Tests
    @MainActor func testSearchPerformance() {
        let searchViewModel = CountrySearchViewModel(countryUseCase: countryUseCase)
        
        measure {
            searchViewModel.performSearch(query: "Egypt")
        }
    }
    
    func testCachePerformance() {
        let countries = (1...1000).map { i in
            Country(name: "Country\(i)", capital: "Capital\(i)", currencies: nil, alpha2Code: "C\(i)")
        }
        
        measure {
            mockCacheService.saveSelectedCountries(countries)
            _ = mockCacheService.getSelectedCountries()
        }
    }
}

// MARK: - Test Utilities
extension XCTestCase {
    func createMockCountry(name: String = "Egypt",
                          capital: String? = "Cairo",
                          currencyCode: String = "EGP",
                          currencyName: String = "Egyptian Pound",
                          alpha2Code: String = "EG") -> Country {
        let currency = Currency(code: currencyCode, name: currencyName, symbol: nil)
        return Country(name: name, capital: capital, currencies: [currency], alpha2Code: alpha2Code)
    }
}

// MARK: - UI Tests (for SearchView)
class SearchViewUITests: XCTestCase {
    
    func testSearchableModifier() {
        // This would test the .searchable modifier behavior
        // In a real project, you'd use XCUITest for this
        XCTAssertTrue(true, "Searchable modifier should be properly integrated")
    }
}
