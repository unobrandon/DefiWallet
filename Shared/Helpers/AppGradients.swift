//
//  Colors+Gradients.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct AppGradients {

    static let emptyAvatarGradients: [LinearGradient] = [purpleGradient, blueGradient,
                                                        sunriseGradient, orangeYellowGradient,
                                                        redOrangeGradient, mintTealGradient,
                                                        greenMintGradient, indigoPurpleGradient]

    static let backgroundFade = LinearGradient(gradient:
                                                Gradient(stops: [.init(color: Color("baseBackground").opacity(0.01), location: 0),
                                                                 .init(color: Color("baseBackground"), location: 1)]),
                                               startPoint: .top, endPoint: .bottom)

    static let purpleGradient = LinearGradient(gradient:
                                                Gradient(colors: [Color(red: 224 / 255, green: 155 / 255, blue: 255 / 255, opacity: 0.2),
                                                                  Color(.sRGB, red: 175 / 255, green: 82 / 255, blue: 254 / 255, opacity: 0.4)]),
                                               startPoint: .top, endPoint: .bottom)

    static let purpleGradient2 = LinearGradient(gradient:
                                                    Gradient(colors: [Color(red: 88 / 255, green: 218 / 255, blue: 255 / 255, opacity: 0.2),
                                                                      Color(.sRGB, red: 148 / 255, green: 109 / 255, blue: 245 / 255, opacity: 0.4)]),
                                                startPoint: .top, endPoint: .bottom)

    static let blueGradient = LinearGradient(gradient:
                                                Gradient(colors: [Color(red: 71 / 255, green: 171 / 255, blue: 255 / 255, opacity: 0.2),
                                                                  Color(.sRGB, red: 31 / 255, green: 118 / 255, blue: 249 / 255, opacity: 0.4)]),
                                             startPoint: .top, endPoint: .bottom)

    static let messageBlueGradient = LinearGradient(gradient:
                                                        Gradient(colors: [Color(red: 97 / 255, green: 195 / 255, blue: 255 / 255, opacity: 0.2),
                                                                          Color(.sRGB, red: 49 / 255, green: 143 / 255, blue: 255 / 255, opacity: 0.4)]),
                                                    startPoint: .top, endPoint: .bottom)

    static let sunriseGradient = LinearGradient(gradient:
                                                    Gradient(colors: [Color(red: 92 / 255, green: 55 / 255, blue: 55 / 255, opacity: 0.15),
                                                                      Color(.sRGB, red: 66 / 255, green: 56 / 255, blue: 100 / 255, opacity: 0.3)]),
                                                startPoint: .top, endPoint: .bottom)

    static let orangeYellowGradient = LinearGradient(gradient:
                                                        Gradient(colors: [Color.yellow.opacity(0.15),
                                                                          Color.orange.opacity(0.3)]),
                                                     startPoint: .top, endPoint: .bottom)

    static let redOrangeGradient = LinearGradient(gradient:
                                                    Gradient(colors: [Color.orange.opacity(0.15), Color.red.opacity(0.3)]),
                                                  startPoint: .top, endPoint: .bottom)

    static let mintTealGradient = LinearGradient(gradient:
                                                    Gradient(colors: [Color(red: 52 / 255, green: 232 / 255, blue: 232 / 255, opacity: 0.3),
                                                                      Color(red: 52 / 255, green: 195 / 255, blue: 232 / 255, opacity: 0.3)]),
                                                 startPoint: .top, endPoint: .bottom)

    static let greenMintGradient = LinearGradient(gradient:
                                                    Gradient(colors: [Color(red: 52 / 255, green: 232 / 255, blue: 208 / 255, opacity: 0.3),
                                                                      Color.green.opacity(0.3)]),
                                                  startPoint: .top, endPoint: .bottom)

    static let indigoPurpleGradient = LinearGradient(gradient:
                                                        Gradient(colors: [Color(red: 114 / 255, green: 178 / 255, blue: 242 / 255, opacity: 0.3),
                                                                Color.purple.opacity(0.3)]),
                                                     startPoint: .top, endPoint: .bottom)

    static let grayGradient = LinearGradient(gradient:
                                                Gradient(colors: [Color(red: 218 / 255, green: 218 / 255, blue: 218 / 255, opacity: 0.25),
                                                                  Color(.sRGB, red: 166 / 255, green: 166 / 255, blue: 166 / 255, opacity: 0.45)]),
                                             startPoint: .top, endPoint: .bottom)

}
