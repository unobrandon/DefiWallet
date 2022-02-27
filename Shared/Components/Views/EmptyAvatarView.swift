//
//  EmptyAvatarView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct EmptyAvatarView: View {

    private let fullName: String
    private let size: CGFloat

    init(fullName: String, size: CGFloat) {
        self.fullName = fullName
        self.size = size
    }

    var body: some View {
        Circle()
            .frame(width: size, height: size, alignment: .center)
            .foregroundColor(Color("baseBackground"))
            .shadow(color: Color.black.opacity(0.15),
                    radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
            .overlay(
                ZStack(alignment: .center) {
                    getGradient(name: fullName)
                        .clipShape(Circle())

                    Text(firstLetters(name: fullName))
                        .font(.system(size: size <= 28 ? 12 : size >= 60 ? 26 : size / 2.33))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.primary)
                }
            )
    }

    private func getGradient(name: String) -> LinearGradient {
        let wordValue = name.wordValue

        let divisible = Int(wordValue / AppGradients.emptyAvatarGradients.count)
        let reminders = AppGradients.emptyAvatarGradients.count * divisible
        let result = wordValue - reminders

        return AppGradients.emptyAvatarGradients[result]
    }

    private func firstLetters(name: String) -> String {
        guard !name.isEmpty else { return "?" }

        var stringNeed: String = ""

        for string in name.components(separatedBy: " ") {
            if stringNeed.count >= 3 {
                return stringNeed
            } else {
                if let firstLetter = string.first {
                    stringNeed += String(firstLetter)
                }
            }
        }

        return stringNeed
    }

}
