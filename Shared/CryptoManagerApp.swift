//
//  CryptoManagerApp.swift
//  Shared
//
//  Created by Вардан Мукучян on 08.04.2022.
//

import SwiftUI

@main
struct CryptoManagerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
