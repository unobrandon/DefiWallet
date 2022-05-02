//
//  EmptyAvatarView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct EmptyAvatar: View {

    private let username: String?
    private let size: CGFloat
    private let style: AppStyle

    init(username: String?, size: CGFloat, style: AppStyle) {
        self.username = username
        self.size = size
        self.style = style
    }

    var body: some View {
        Circle()
            .frame(width: size, height: size, alignment: .center)
            .irregularGradient(colors: getIrregularGradient(), backgroundColor: Color("baseButton_selected"), speed: 6)
            .shadow(color: Color.black.opacity(style == .shadow ? 0.175 : 0.0),
                    radius: size > 40 ? (size / 7) : size < 25 ? 3 : 5, x: 0, y: size > 40 ? (size / 8) : size < 25 ? 3 : 5)
            .overlay(
                ZStack(alignment: .center) {
                    if let username = username, !username.isEmpty {
                        getGradient(name: username)
                            .clipShape(Circle())

                        Text(firstLetters(name: username))
//                            .font(.system(size: size <= 28 ? 12 : size >= 60 ? 26 : size / 2.33))
                            .fontWeight(.semibold)
                            .irregularGradient(colors: [.orange, .red, .orange, .yellow, .orange, .red], backgroundColor: .orange, speed: 5)
                    }
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

    private func getIrregularGradient() -> [Color] {
        if let username = username, !username.isEmpty {
            return [.clear]
        } else {
            return [.orange, .yellow, .red]
        }
    }

    private func firstLetters(name: String) -> String {
        guard !name.isEmpty else { return "?" }
        guard !name.contains("0x") else { return "\(name.suffix(2))" }

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
