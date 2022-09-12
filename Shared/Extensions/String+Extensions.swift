//
//  String+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

extension String {

    var wordValue: Int { compactMap(\.letterValue).reduce(0, +) }

    func cleanUpPastedText() -> String {
        let stage1 = self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
        let stage2 = stage1.replacingOccurrences(of: ">", with: "")
        let components = stage2.components(separatedBy: .whitespacesAndNewlines)

        return components.filter { !$0.isEmpty }.joined(separator: " ").lowercased()
     }

    func countWords() -> Int? {
        guard !self.isEmpty else { return nil }

        let components = self.components(separatedBy: .whitespacesAndNewlines)
        let words = components.filter { !$0.isEmpty }

        return words.count
    }

    func forTrailingZero(temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }

    func formatNetwork() -> String {
        guard !self.isEmpty else { return self }

        if self == "polygon" {
            return "ply"
        } else if self == "avalanche" {
            return "avax"
        } else if self == "fantom" {
            return "ftm"
        } else {
            return self
        }
    }

    func format1InchNetwork() -> String {
        guard !self.isEmpty else { return self }

        if self == "polygon" {
            return "137"
        } else if self == "avalanche" {
            return "43114"
        } else if self == "bsc" {
            return "56"
        } else if self == "eth" {
            return "1"
        } else if self == "fantom" {
            return "250"
        } else {
            return self
        }
    }

    func formatAddress(_ prefix: Int? = nil) -> String {
        guard !self.contains(".eth") else {
           return self
        }

        return self.prefix(prefix ?? 4) + "..." + self.suffix(prefix ?? 4)
    }

    func formatAddressExtended() -> String {
        guard !self.contains(".eth") else {
           return self
        }

        return self.prefix(8) + "..." + self.suffix(8)
    }

    func formatLargeNumber(_ number: Int, size: ControlSize? = .small, scale: Int? = 1) -> String {
        let num = abs(Double(number))
        let sign = (number < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            var formatted = num / 1_000_000_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "t" : size == .large ? " trillion" : " tril"

            return "\(sign)\(formatted)\(amount)"

        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "b" : size == .large ? " billion" : " bil"

            return "\(sign)\(formatted)\(amount)"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "m" : size == .large ? " million" : " mil"

            return "\(sign)\(formatted)\(amount)"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "k" : size == .large ? " thousand" : " thsnd"

            return "\(sign)\(formatted)\(amount)"

        case 0...:
            return "\(number)"

        default:
            return "\(sign)\(number)"
        }
    }

    func formatLargeDoubleNumber(_ number: Double, size: ControlSize? = .small, scale: Int? = 1) -> String {
        let num = abs(number)
        let sign = (number < 0) ? "-" : ""

        switch num {
        case 1_000_000_000_000...:
            var formatted = num / 1_000_000_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "t" : size == .large ? " trillion" : " tril"

            return "\(sign)\(formatted)\(amount)"

        case 1_000_000_000...:
            var formatted = num / 1_000_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "b" : size == .large ? " billion" : " bil"

            return "\(sign)\(formatted)\(amount)"

        case 1_000_000...:
            var formatted = num / 1_000_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "m" : size == .large ? " million" : " mil"

            return "\(sign)\(formatted)\(amount)"

        case 1_000...:
            var formatted = num / 1_000
            formatted = formatted.reduceScale(to: scale ?? 1)
            let amount = size == .small ? "k" : size == .large ? " thousand" : " thsnd"

            return "\(sign)\(formatted)\(amount)"

        case 0...:
            return "\(number)"

        default:
            return "\(sign)\(number)"
        }
    }

    func createDateTime() -> String {
        var strDate = "undefined"

        if let unixTime = Double(self) {
            let date = Date(timeIntervalSince1970: unixTime)
            let dateFormatter = DateFormatter()
            let timezone = TimeZone.current.abbreviation() ?? "CET"
            dateFormatter.timeZone = TimeZone(abbreviation: timezone)
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            strDate = dateFormatter.string(from: date)
        }

        return strDate
    }

    func getFullElapsedInterval() -> String {
        guard let unixTime = Double(self) else {
            return ""
        }

        let date = Date(timeIntervalSince1970: unixTime)
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: Date())

        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
            "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
            "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
            "\(day)" + " " + "days"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour" :
            "\(hour)" + " " + "hours"
        } else if let min = interval.minute, min > 0 {
            return min == 1 ? "\(min)" + " " + "minute" :
            "\(min)" + " " + "minutes"
        } else if let sec = interval.second, sec > 0 {
            return sec == 1 ? "\(sec)" + " " + "second" :
            "\(sec)" + " " + "seconds"
        } else {
            return "just now"
        }
    }

    func toArray() throws -> [Any] {
        guard let stringData = data(using: .utf16, allowLossyConversion: false) else { return [] }
        guard let array = try JSONSerialization.jsonObject(with: stringData, options: .mutableContainers) as? [Any] else {
             throw JSONError.notArray
        }

        return array
    }

    func toDictionary() throws -> [String: Any] {
        guard let binData = data(using: .utf16, allowLossyConversion: false) else { return [:] }
        guard let json = try JSONSerialization.jsonObject(with: binData, options: .allowFragments) as? [String: Any] else {
            throw JSONError.notNSDictionary
        }

        return json
    }

    func listCountriesAndCurrencies() throws -> [String: String] {
        let localeIds = Locale.availableIdentifiers
        var countryCurrency = [String: String]()
        for localeId in localeIds {
            let locale = Locale(identifier: localeId)

            if let country = locale.regionCode {
                if let currency = locale.currencySymbol {
                    countryCurrency[country] = currency
                }
            }
        }

        return countryCurrency
    }

}
