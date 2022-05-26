//
//  BorderedSelectedButton.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/17/22.
//

import SwiftUI

struct BorderedSelectedButton: View {

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
                Text(title).fontTemplate(FontTemplate(font: Font.system(size: 11.0, design: .monospaced), weight: .bold, foregroundColor: tint ?? .gray.opacity(0.2), lineSpacing: 0))
            } else {
                Text(title)
            }
        })
        .padding(.vertical, 4)
        .padding(.horizontal, 10)
        .background(tint?.opacity(0.1) ?? .gray.opacity(0.05))
        .cornerRadius(5)
        .buttonStyle(ClickInteractiveStyle(0.98))
    }

    private func actionTap() {
        #if os(iOS)
            HapticFeedback.lightHapticFeedback()
        #endif

        action()
    }

}
