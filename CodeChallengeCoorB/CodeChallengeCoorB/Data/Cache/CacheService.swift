//
//  CacheService.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import Foundation
protocol CacheServiceProtocol {
    func saveCountries(_ countries: [Country], for searchTerm: String)
    func getCountries(for searchTerm: String) -> [Country]?
    func saveSelectedCountries(_ countries: [Country])
    func getSelectedCountries() -> [Country]
    func clearCache()
}

class CacheService: CacheServiceProtocol {
    private let userDefaults = UserDefaults.standard
    private let searchCacheKey = "search_cache_"
    private let selectedCountriesKey = "selected_countries"
    
    func saveCountries(_ countries: [Country], for searchTerm: String) {
        let key = searchCacheKey + searchTerm.lowercased()
        if let data = try? JSONEncoder().encode(countries) {
            userDefaults.set(data, forKey: key)
        }
    }
    
    func getCountries(for searchTerm: String) -> [Country]? {
        let key = searchCacheKey + searchTerm.lowercased()
        guard let data = userDefaults.data(forKey: key),
              let countries = try? JSONDecoder().decode([Country].self, from: data) else {
            return nil
        }
        return countries
    }
    
    func saveSelectedCountries(_ countries: [Country]) {
        if let data = try? JSONEncoder().encode(countries) {
            print(data)
            userDefaults.set(data, forKey: selectedCountriesKey)
        }
    }
    
    func getSelectedCountries() -> [Country] {
        guard let data = userDefaults.data(forKey: selectedCountriesKey),
              let countries = try? JSONDecoder().decode([Country].self, from: data) else {
            return []
        }
        return countries
    }
    
    func clearCache() {
        let keys = userDefaults.dictionaryRepresentation().keys.filter { $0.hasPrefix(searchCacheKey) }
        keys.forEach { userDefaults.removeObject(forKey: $0) }
        userDefaults.removeObject(forKey: selectedCountriesKey)
    }
}
