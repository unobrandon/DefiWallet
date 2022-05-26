//
//  GridItem.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct GridItem: Identifiable {
    let view: AnyView
    let id: AnyHashable
}
