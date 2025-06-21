//
//  NetworkLayer.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

import Foundation

// MARK: - Network Service
protocol NetworkServiceProtocol {
    func fetchCountries(by name: String) async throws -> [Country]
    func fetchCountryByCode(_ code: String) async throws -> Country?
}

class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://restcountries.com/v2"
    
    func fetchCountries(by name: String) async throws -> [Country] {
        guard let url = URL(string: "\(baseURL)/name/\(name)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
            return countries
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    func fetchCountryByCode(_ code: String) async throws -> Country? {
        guard let url = URL(string: "\(baseURL)/alpha/\(code)") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let country = try JSONDecoder().decode(Country.self, from: data)
            return country
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
