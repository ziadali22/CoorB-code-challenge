//
//  HomeViewModel.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var selectedCountries: [Country] = []
    @Published var errorMessage: String?
    @Published var isInitializing: Bool = true
    
    private let cacheService: CacheServiceProtocol
    private let countryUseCase: CountryUseCaseProtocol
    private let locationManager: any LocationManagerProtocol
    private let maxCountries = 5
    private let defaultCountryCode = "EG"
    
    init(cacheService: CacheServiceProtocol, countryUseCase: CountryUseCaseProtocol, locationManager: any LocationManagerProtocol) {
        self.cacheService = cacheService
        self.countryUseCase = countryUseCase
        self.locationManager = locationManager
        
        Task {
            await initializeCountries()
        }
        
    }
    
    private func initializeCountries() async {
        loadSelectedCountries()

        if selectedCountries.isEmpty {
            await addLocationBasedCountry()
        }
        
        isInitializing = false
    }
    
    private func loadSelectedCountries() {
        selectedCountries = cacheService.getSelectedCountries()
    }
    
    private func saveSelectedCountries() {
        cacheService.saveSelectedCountries(selectedCountries)
    }
    
    private func addLocationBasedCountry() async {
        locationManager.requestLocationPermission()
        
        // Wait a bit for permission response
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let countryCode = await locationManager.getCurrentCountryCode() ?? defaultCountryCode
        
        do {
            if let country = try await countryUseCase.getCountry(by: countryCode) {
                selectedCountries.append(country)
                saveSelectedCountries()
            }
        } catch {
            // If location-based country fails, try default country
            if countryCode != defaultCountryCode {
                do {
                    if let defaultCountry = try await countryUseCase.getCountry(by: defaultCountryCode) {
                        selectedCountries.append(defaultCountry)
                        saveSelectedCountries()
                    }
                } catch {
                    errorMessage = "Failed to load default country: \(error.localizedDescription)"
                }
            }
        }
    }
    
    
    func addCountry(_ country: Country) {
        guard selectedCountries.count < maxCountries else {
            errorMessage = "Maximum \(maxCountries) countries allowed"
            return
        }
        
        guard !selectedCountries.contains(country) else {
            errorMessage = "Country already added"
            return
        }
        
        selectedCountries.append(country)
        saveSelectedCountries()
        errorMessage = nil
    }
    
    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0.id == country.id }
        saveSelectedCountries()
    }
    
    func clearError() {
        errorMessage = nil
    }
    
    var canAddMoreCountries: Bool {
        selectedCountries.count < maxCountries
    }
}
