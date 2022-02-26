//
//  WelcomeCarousel.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct MainCarouselView: View {
    var body: some View {
        #if targetEnvironment(macCatalyst)
            CarouselViewTwo()
        #elseif os(macOS)
            CarouselViewOne()
        #elseif os(iOS)
            WelcomeCarouselView()
        #endif
    }
}
