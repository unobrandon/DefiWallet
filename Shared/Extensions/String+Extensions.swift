//
//  String+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI

extension String {

    public func formatAddress(_ address: String) -> String {
        return address.prefix(6) + "..." + address.suffix(4)
    }

}
