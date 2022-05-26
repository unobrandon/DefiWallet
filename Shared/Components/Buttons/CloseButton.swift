//
//  CloseButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/19/22.
//

import SwiftUI

struct CloseButton: View {

    private let size: Int
    private let action: () -> Void

    init(size: Int, action: @escaping () -> Void) {
        self.size = size
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            SOCExitButton()
        }.frame(width: CGFloat(size), height: CGFloat(size))
    }

}

struct CloseButton_Previews: PreviewProvider {
    static var previews: some View {
        CloseButton(size: 38, action: {
            print("hi")
        })
    }
}
