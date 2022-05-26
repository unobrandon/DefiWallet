//
//  iosConsants.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/12/22.
//

import SwiftUI

struct MobileConstants {

    static let deviceType = UIDevice.current.userInterfaceIdiom

    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height

    static let appName: String = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? ""
    static let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""

}
