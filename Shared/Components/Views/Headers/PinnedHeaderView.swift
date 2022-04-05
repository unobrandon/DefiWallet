//
//  StickeyHeaderView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI
import SwiftUIX

struct PinnedHeaderView: View {

    @Binding var currentType: String
    @Namespace var animation

    private let sections: [String]
    private let style: AppStyle
    var action: () -> Void

    init(currentType: Binding<String>, sections: [String], style: AppStyle, action: @escaping () -> Void) {
        self._currentType = currentType
        self.sections = sections
        self.style = style
        self.action = action
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(sections, id: \.self) { type in
                    VStack(spacing: 7.5) {
                        Text(type).fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .semibold, foregroundColor: currentType == type ? .primary : .secondary, lineSpacing: 0))

                        ZStack {
                            if currentType == type {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.primary)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous).fill(.clear)
                            }
                        }.frame(height: 4)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        action()
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
        .background(VisualEffectBlurView(blurStyle: .systemThinMaterial))
    }
}
