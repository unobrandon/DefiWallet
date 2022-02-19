//
//  TabBarButton.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct TabBarButton: View {

    let image: String
    let title: String

    @ObservedObject var services: AuthenticatedServices
    @State private var hoverOver = false

    var action: () -> Void

    var body: some View {
        Button(action: withAnimation { action }, label: {
            HStack(spacing: 10) {
                Image(systemName: image)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(services.macTabStatus.rawValue == title.lowercased() || hoverOver ? .primary : .secondary)
                    .padding(.leading, 10)

                Text(title)
                    .font(.headline)
                    .fontWeight(services.macTabStatus.rawValue == title.lowercased() || hoverOver ? .medium : .regular)
                    .foregroundColor(services.macTabStatus.rawValue == title.lowercased() || hoverOver ? .primary : .secondary)
                    .lineLimit(1)
                    .fixedSize()

                Spacer()
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        })
        .buttonStyle(PlainButtonStyle())
        .background(Color.primary.opacity(services.macTabStatus.rawValue == title.lowercased() || hoverOver ? 0.15 : 0))
        .cornerRadius(10)
//        .scaleEffect(hoverOver ? 1.03 : 1.0)
        .onHover { over in
            withAnimation(.easeOut) {
                hoverOver = over
            }
        }
    }
}
