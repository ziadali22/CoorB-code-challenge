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
    private let maxCountries = 5
    
    init(cacheService: CacheServiceProtocol) {
        self.cacheService = cacheService
        
        initializeCountries()
    }
    
    private func initializeCountries() {
        loadSelectedCountries()
        
        isInitializing = false
    }
    
    private func loadSelectedCountries() {
        selectedCountries = cacheService.getSelectedCountries()
    }
    
    private func saveSelectedCountries() {
        cacheService.saveSelectedCountries(selectedCountries)
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
