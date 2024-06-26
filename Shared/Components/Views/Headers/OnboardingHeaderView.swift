//
//  OnboardingHeaderView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct OnboardingHeaderView: View {

    private let imageName: String
    private let title: String
    private let subtitle: String

    init(imageName: String, title: String, subtitle: String) {
        self.imageName = imageName
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HeaderIcon(size: 48, imageName: imageName)
                .rotationEffect(.init(degrees: imageName == "key" ? 45 : 0))
                .padding(.bottom, 10)

            Text(title)
                .fontTemplate(DefaultTemplate.headingSemiBold)
                .multilineTextAlignment(.center)

            Text(subtitle)
                .fontTemplate(DefaultTemplate.body_Mono_secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }

}
