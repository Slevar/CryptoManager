//
//  String.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 20.04.2022.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
