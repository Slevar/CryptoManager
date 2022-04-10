//
//  Double.swift
//  CryptoManager (iOS)
//
//  Created by Вардан Мукучян on 09.04.2022.
//

import Foundation

extension Double {

    
    /// Convert a Double to Currency with 2 decimal
    /// ```
    /// Convert 1234.56 to $1,234,56
    /// ```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// Convert a Double to Currency as a String with 2 decimal
    /// ```
    /// Convert 1234.56 to "$1,234,56"
    /// ```
    func asCurrencyWith2Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }

    /// Convert a Double to Currency with 2-6 decimal
    /// ```
    /// Convert 1234.56 to $1,234,56
    /// Convert 12.3456 to $12,3456
    /// Convert 0.123456 to $0,123456
    /// ```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// Convert a Double to Currency as a String with 2-6 decimal
    /// ```
    /// Convert 1234.56 to "$1,234,56"
    /// Convert 12.3456 to "$12,3456"
    /// Convert 0.123456 to "$0,123456"
    /// ```
    func asCurrencyWith6Decimals() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Convert a Double into a String, with 2 numbers after decimal
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Convert a Double into a String, with 2 numbers after decimal
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
