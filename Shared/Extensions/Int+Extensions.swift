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

}
