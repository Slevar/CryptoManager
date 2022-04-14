//
//  UIApplication.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 10.04.2022.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    // При вызове функции уберёт клавиутуру 
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
