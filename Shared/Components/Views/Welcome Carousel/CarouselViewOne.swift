//
//  SwiftUIView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/25/22.
//

import SwiftUI

struct CarouselViewOne: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Image("welcomeCarouselThree")
                .resizable()
                .scaledToFit()

            Text("YOUR\nNEW DIFI\nDASHBOARD")
                .fontTemplate(DefaultTemplate.titleBold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
        }
    }
}
