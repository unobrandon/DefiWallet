//
//  StatusBar.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/12/22.
//

import SwiftUI

struct StatusBar: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .frame(width: 250)
        .frame(minHeight: 100, idealHeight: 150, maxHeight: 750)
    }
}

struct StatusBar_Previews: PreviewProvider {
    static var previews: some View {
        StatusBar()
    }
}
