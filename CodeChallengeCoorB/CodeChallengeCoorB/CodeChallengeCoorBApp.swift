//
//  CodeChallengeCoorBApp.swift
//  CodeChallengeCoorB
//
//  Created by Ziad Khalil on 19/06/2025.
//

import SwiftUI

@main
struct CodeChallengeCoorBApp: App {
    @StateObject private var container = DIContainer()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(container)
        }
    }
}
