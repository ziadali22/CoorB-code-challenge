//
//  Country.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 20/06/2025.
//

struct Country: Codable, Identifiable, Equatable {
    let name: String
    let capital: String?
    let currencies: [Currency]?
    let alpha2Code: String
    
    var id: String { alpha2Code }
    
    var displayCapital: String {
        capital ?? "N/A"
    }
    
    var displayCurrency: String {
        currencies?.first?.name ?? "N/A"
    }
    
    var displayCurrencyCode: String {
        currencies?.first?.code ?? "N/A"
    }
    
    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.alpha2Code == rhs.alpha2Code
    }
}

struct Currency: Codable {
    let code: String?
    let name: String?
    let symbol: String?
}
