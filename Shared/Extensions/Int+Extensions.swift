//
//  Int+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/30/22.
//

import Foundation

extension Int {
    
    func convertEpochDate(monthFormat: Bool? = true) -> String {
        let truncatedTime = Int(self / 1000)
        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = monthFormat ?? true ? "MMM d, yy'" : "HH:mm"
        return formatter.string(from: date)
    }

    func getElapsedInterval() -> String {
        let truncatedTime = Int(self / 1000)

        let date = Date(timeIntervalSince1970: TimeInterval(truncatedTime))
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
