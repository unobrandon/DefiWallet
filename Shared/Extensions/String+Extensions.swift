//
//  String+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

extension String {

    public func formatAddress(_ address: String) -> String {
        guard !address.contains(".eth") else {
           return address
        }

        return address.prefix(4) + "..." + address.suffix(4)
    }

    public func createDateTime(_ timestamp: String) -> String {
        var strDate = "undefined"

        if let unixTime = Double(timestamp) {
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

}
