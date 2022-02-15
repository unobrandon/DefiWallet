//
//  Font+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI

extension Font {

    public func italic(_ value: Bool) -> Font {
        return value ? self.italic() : self
    }

}
