//
//  HeaderIcon.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/2/22.
//

import SwiftUI

struct HeaderIcon: View {

    private let size: CGFloat
    private let image: String

    init(size: CGFloat, imageName: String) {
        self.size = size
        self.image = imageName
    }

    var body: some View {
        Image(systemName: image)
            .resizable()
            .scaledToFit()
            .font(Font.title.weight(.medium))
            .frame(width: size, height: size, alignment: .center)
            .irregularGradient(colors: [.blue, .orange, .red, .yellow], backgroundColor: .pink, speed: 4)
    }

}
