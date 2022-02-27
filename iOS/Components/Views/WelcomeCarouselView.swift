//
//  WelcomeCarouselView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import SwiftUIX

struct WelcomeCarouselView: View {

    @State var currentPage = 0

    var body: some View {
        PaginationView(axis: .horizontal, showsIndicators: true) {
            CarouselViewOne()
            CarouselViewTwo()
        }
        .currentPageIndex($currentPage)
        .pageIndicatorAlignment(.bottomLeading)
        .pageIndicatorTintColor(Color.systemGray5.opacity(0.75))
        .currentPageIndicatorTintColor(.primary)
    }

}
