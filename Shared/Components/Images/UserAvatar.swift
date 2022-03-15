//
//  UserProfileImage.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI

struct UserAvatar: View {

    private let size: CGFloat
    private let user: CurrentUser
    private let style: AppStyle

    init(size: CGFloat, user: CurrentUser, style: AppStyle) {
        self.size = size
        self.user = user
        self.style = style
    }

    var body: some View {
        if let image = user.avatar, !image.isEmpty {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size, alignment: .center)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(style == .shadow ? 0.175 : 0.0),
                        radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
        } else {
            EmptyAvatar(username: user.username, size: size, style: style)
        }
    }

}
