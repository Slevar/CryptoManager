//
//  HapticManager.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 14.04.2022.
//

import Foundation
import UIKit

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
