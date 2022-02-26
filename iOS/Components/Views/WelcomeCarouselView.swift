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
        PaginationView(axis: .horizontal, showsIndicators: false) {
            CarouselViewOne()
            CarouselViewTwo()
        }
        .currentPageIndex($currentPage)
        .pageIndicatorAlignment(.bottom)
        .pageIndicatorTintColor(.systemGray4)
        .currentPageIndicatorTintColor(.black)
    }
}
