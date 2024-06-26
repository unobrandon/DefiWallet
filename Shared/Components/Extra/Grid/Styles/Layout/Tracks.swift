//
//  Tracks.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI

public enum Tracks: Hashable {
    case count(Int)
    case fixed(CGFloat)
    case min(CGFloat)
}

extension Tracks: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Self.IntegerLiteralType) {
        self = .count(value)
    }

}
