//
//  CryptoManagerApp.swift
//  Shared
//
//  Created by Вардан Мукучян on 08.04.2022.
//

import SwiftUI

@main
struct CryptoManagerApp: App {
    
    @StateObject private var vm = HomeViewModel()
        
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            // Теперь всё, что находится внутри NavigationViewимеет доступ к объекту "vm", то есть к нашей ViewModel
            .environmentObject(vm)
        }
    }
}
