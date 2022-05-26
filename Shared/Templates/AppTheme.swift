//
//  AppTheme.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

enum AppStyle: Equatable {
    case border
    case shadow
}

final class AppTheme {
    // Purpose is to enable multiple themes to select from
    // Class will hold the current state theme

    var currentStyle: AppStyle

    init(_ style: AppStyle) {
        self.currentStyle = style
    }

}
