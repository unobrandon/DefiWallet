//
//  macConstants.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct MacConstants {

    static let screenWidth = NSScreen.main?.visibleFrame.width ?? 1400
    static let screenHeight = NSScreen.main?.visibleFrame.height ?? 1000

    static let appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

}
