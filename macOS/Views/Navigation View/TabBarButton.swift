//
//  TabBarButton.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct TabBarButton: View {
    
    var image: String
    var title: String

    @Binding var selectedTab : String
    @State private var hoverOver = false

    var body: some View {
        Button(action: { withAnimation{ selectedTab = title }}, label: {
            HStack(spacing: 10) {
                Image(systemName: image)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selectedTab == title || hoverOver ? .primary : .secondary)
                    .padding(.leading)

                Text(title)
                    .font(.headline)
                    .fontWeight(selectedTab == title || hoverOver ? .medium : .regular)
                    .foregroundColor(selectedTab == title || hoverOver ? .primary : .secondary)
                
                Spacer()
            }
            .padding(.vertical, 10)
            .frame(width: 180)
            .contentShape(Rectangle())
            .background(Color.primary.opacity(selectedTab == title || hoverOver ? 0.15 : 0))
            .cornerRadius(10)
            .scaleEffect(hoverOver ? 1.03 : 1.0)
        })
        .buttonStyle(PlainButtonStyle())
        .onHover { over in
            withAnimation(.easeOut) {
                hoverOver = over
            }
        }
    }
}
