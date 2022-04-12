//
//  Color+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI

extension UIColor {

    static public func hexStringToUIColor(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
          cString.remove(at: cString.startIndex)
        }

        if cString.count != 6 {
            return UIColor.secondarySystemFill
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255,
                       blue: CGFloat((rgbValue & 0x0000FF)) / 255,
                       alpha: CGFloat(1.0))
    }

    public var hexString: String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        let rgb: Int = (Int)(red * 255) << 16 | (Int)(green * 255) << 8 | (Int)(blue * 255) << 0

        return String(format:"#%06x", rgb)
    }

}
