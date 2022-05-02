//
//  Color+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/10/22.
//

import SwiftUI

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

#if os(iOS) || os(tvOS) || os(watchOS)
    typealias Colorr = UIColor
#elseif os(OSX)
    typealias Colorr = NSColor
#endif

extension Colorr {

    static func fromHSL(hhh: Double, sss: Double, lll: Double) -> Colorr? {
        let ccc = (1 - abs(2 * lll - 1)) * sss
        let xxx = ccc * (1 - abs((hhh / 60).truncatingRemainder(dividingBy: 2) - 1))
        let mmm = lll - (ccc / 2)

        let (tmpR, tmpG, tmpB): (Double, Double, Double)
        if 0 <= hhh && hhh < 60 {
            (tmpR, tmpG, tmpB) = (ccc, xxx, 0)
        } else if 60 <= hhh && hhh < 120 {
            (tmpR, tmpG, tmpB) = (xxx, ccc, 0)
        } else if 120 <= hhh && hhh < 180 {
            (tmpR, tmpG, tmpB) = (0, ccc, xxx)
        } else if 180 <= hhh && hhh < 240 {
            (tmpR, tmpG, tmpB) = (0, xxx, ccc)
        } else if 240 <= hhh && hhh < 300 {
            (tmpR, tmpG, tmpB) = (xxx, 0, ccc)
        } else if 300 <= hhh && hhh < 360 {
            (tmpR, tmpG, tmpB) = (ccc, 0, xxx)
        } else {
            return nil
        }

        let rrr = (tmpR + mmm)
        let ggg = (tmpG + mmm)
        let bbb = (tmpB + mmm)

        return Colorr(red: CGFloat(rrr), green: CGFloat(ggg), blue: CGFloat(bbb), alpha: 1)
    }

}

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
