//
//  FontTemplating.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI

public protocol FontTemplating {

    var font: Font { get }
    var weight: Font.Weight { get }
    var foregroundColor: Color { get }
    var italic: Bool { get }
    var lineSpacing: CGFloat { get }

}
