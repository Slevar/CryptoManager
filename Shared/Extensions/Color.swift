//
//  Color.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 08.04.2022.
//

import Foundation
import SwiftUI

extension Color {
    
    static let theme = ColorTheme()

}

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let backgroundColor = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let secondaryText = Color("SecondaryTextColor")
}
