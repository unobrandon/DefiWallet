//
//  LoadMoreScrollView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/22/22.
//

import SwiftUI
import SwiftUIX

// MARK: Do not use! The view interacts weird with the tab bar.

struct LoadMoreScrollView<Content: View>: View {

    @State private var scrollHeight: CGFloat = 0
    @Binding var enableLoadMore: Bool
    @Binding var showIndicator: Bool
    private let onLoadMore: () -> Void
    private let content: Content

    init(enableLoadMore: Binding<Bool>, showIndicator: Binding<Bool>, onLoadMore: @escaping () -> Void, @ViewBuilder _ content: () -> Content) {
        self._enableLoadMore = enableLoadMore
        self._showIndicator = showIndicator
        self.onLoadMore = onLoadMore
        self.content = content()
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            LazyVStack(alignment: .center, spacing: 0) {
                content

                if showIndicator {
                    ActivityIndicator().animated(true).style(.regular)
                        .padding(.vertical)
                }
            }
            .background(GeometryReader { fullView in
                Color.clear.preference(key: ViewOffsetKey.self, value: -fullView.frame(in: .named("scroll")).origin.y)
                    .onAppear {
                        scrollHeight = fullView.size.height
                    }
                    .onChange(of: fullView.size.height) {
                        scrollHeight = $0
                    }
            })
            .onPreferenceChange(ViewOffsetKey.self) { offset in
                guard enableLoadMore, scrollHeight != 0 else { return }

                if offset + MobileConstants.screenHeight >= scrollHeight {
                    enableLoadMore = false
                    onLoadMore()
                }
            }
        }
    }

}
