//
//  StickyHeaderOffsetModifier.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct PinnedHeaderOffsetModifier: ViewModifier {

    @Binding var offset: CGFloat

    var returnFromStart: Bool = true
    @State var startValue: CGFloat = 0

    func body(content: Content) -> some View {
        content.overlay {
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: PinnedOffsetKey.self, value: proxy.frame(in: .named("SCROLL")).minY)
                        .onPreferenceChange(PinnedOffsetKey.self) { value in
                            if startValue == 0 {
                                startValue = value
                            }

                            offset = (value - (returnFromStart ? startValue : 0))
                        }
                }
            }
    }
}

// MARK: Preference Key
struct PinnedOffsetKey: PreferenceKey {

    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

}
