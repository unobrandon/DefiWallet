//
//  GridPreferencesKey.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import Foundation
import SwiftUI

public struct GridPreferencesKey: PreferenceKey {

    public static var defaultValue: GridPreferences = .init(items: [])

    public static func reduce(value: inout GridPreferences, nextValue: () -> GridPreferences) {
        value.merge(with: nextValue())
    }

}
