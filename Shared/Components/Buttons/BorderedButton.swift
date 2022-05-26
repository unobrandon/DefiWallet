//
//  BorderedButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct BorderedButton: View {

    private let title: String
    private var systemImage: String?
    private let buttonSize: ControlSize?
    private let tint: Color?
    private let action: () -> Void

    init(title: String, systemImage: String? = nil, size: ControlSize? = .small, tint: Color? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.buttonSize = size
        self.tint = tint ?? .primary
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.actionTap()
        }, label: {
            if let systemImage = systemImage {
                Label(title, systemImage: systemImage)
            } else if buttonSize == .mini {
                Text(title).fontTemplate(FontTemplate(font: Font.system(size: 11.0, design: .monospaced), weight: .semibold, foregroundColor: tint ?? .primary, lineSpacing: 0))
            } else {
                Text(title)
            }
        })
        .buttonStyle(.bordered)
        .controlSize(buttonSize ?? .small)
        .buttonBorderShape(.roundedRectangle)
        .tint(tint)
        .buttonStyle(ClickInteractiveStyle(0.99))
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
