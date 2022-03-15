//
//  BorderlessButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct BorderlessButton: View {

    private let title: String
    private var systemImage: String?
    private let buttonSize: ControlSize?
    private let action: () -> Void

    init(title: String, systemImage: String? = nil, size: ControlSize? = .small, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.buttonSize = size
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.actionTap()
        }, label: {
            Label(title, systemImage: systemImage ?? "")
        })
        .buttonStyle(.borderless)
        .controlSize(buttonSize ?? .small)
        .buttonBorderShape(.roundedRectangle)
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
