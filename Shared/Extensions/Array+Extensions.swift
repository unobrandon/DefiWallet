//
//  Array+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/30/22.
//

import Foundation

extension Array {

    func subArray(length: Int) -> [Element] {
        precondition(length >= 0, "length must not be negative")
        if length >= count { return self }
        let oldMax = Double(count - 1)
        let newMax = Double(length - 1)
        return (0..<length).map { self[Int((Double($0) * oldMax / newMax).rounded())] }
    }

}
