//
//  Double+Extenions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/10/22.
//

import Foundation

extension Double {

    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }

    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }

    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        formatter.locale = Locale.current

        return formatter.string(from: .init(value: self)) ?? ""
    }

    func formatCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }

    func decimalCount() -> Int {
            if self == Double(Int(self)) {
                return 0
            }

            let integerString = String(Int(self))
            let doubleString = String(Double(self))
            let decimalCount = doubleString.count - integerString.count - 1

            return decimalCount
        }

}
