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
    var action: (String) -> Void

    init(currentType: Binding<String>, sections: [String], style: AppStyle, action: @escaping (String) -> Void) {
        self._currentType = currentType
        self.sections = sections
        self.style = style
        self.action = action
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(sections, id: \.self) { type in
                    VStack(spacing: 5) {
                        Text(type).fontTemplate(FontTemplate(font: Font.custom("Poppins-Medium", size: 16), weight: .semibold, foregroundColor: currentType == type ? .primary : .secondary, lineSpacing: 0))

                        ZStack {
                            if currentType == type {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.primary)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous).fill(.clear)
                            }
                        }.frame(height: 2)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                        action(type)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal)
        }
        .background(BlurEffectView(style: .systemMaterial))
    }
}

// MARK: How to use

//    LazyVStack(pinnedViews: [.sectionHeaders]) {
//        Section {
//            Grid(gridViews.indices, id: \.self) { gridViews[$0] }
//        } header: {
//            PinnedHeaderView(currentType: $currentTab, sections: ["All", "Tokens", "Collectables"], style: service.themeStyle, action: {
//                print("tapped new section")
//            })
//            .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
//            .modifier(PinnedHeaderOffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
//            .modifier(PinnedHeaderOffsetModifier(offset: $headerOffsets.1))
//        }
//    }
