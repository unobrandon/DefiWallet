//
//  ViewOffsetKey.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {

    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }

}
