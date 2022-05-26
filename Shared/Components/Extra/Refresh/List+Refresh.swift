//
//  List+Refresh.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 5/10/22.
//

import SwiftUI

@available(iOS 13.0, *)
extension ScrollView {
    
    public func enableRefresh(_ enable: Bool = true) -> some View {
        modifier(Refresh.Modifier(enable: enable))
    }

}
