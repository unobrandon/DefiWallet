//
//  GridItemBoundsPreferencesKey.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI

public struct GridItemBoundsPreferencesKey: PreferenceKey {

    public static var defaultValue: [CGRect] = []

    public static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }

}
