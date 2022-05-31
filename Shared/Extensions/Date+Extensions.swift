//
//  Date+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import Foundation

extension Date {

    func mediumDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)
    }

    func shortDateFormate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter.string(from: self)
    }

    func millisecondsSince1970() -> Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

}
