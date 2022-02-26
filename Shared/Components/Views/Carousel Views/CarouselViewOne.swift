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
            Image("welcomeCarouselOne")
                .resizable()
                .scaledToFit()

            Text("YOUR\nNEW DIFI\nDASHBOARD")
                .fontTemplate(DefaultTemplates.title)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
        }
    }
}
