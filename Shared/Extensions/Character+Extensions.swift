//
//  Character+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import Foundation

extension Character {

    static let alphabetValue = zip("abcdefghijklmnopqrstuvwxyz", 1...26).reduce(into: [:]) { $0[$1.0] = $1.1 }

    var lowercased: Character { .init(lowercased()) }

    var letterValue: Int? { Self.alphabetValue[lowercased] }

}
