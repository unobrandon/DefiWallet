//
//  CategoriesSectionView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/8/22.
//

import SwiftUI

struct TopSectionView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    @State private var placeholderItems: [String] = ["welcomeCarouselThree", "gradientBg1", "gradientBg2", "gradientBg3"]

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            // MARK: Top Categories / Exchanges
            HStack(alignment: .center, spacing: 5) {
                Button(action: {
                    print("Top Categories")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Image(systemName: "list.number")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18, alignment: .center)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.black)

                            Text("Top Categories")
                                .fontTemplate(DefaultTemplate.subheadingMedium_black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 10, style: .circular).foregroundColor(Color("softPurple")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))

                Button(action: {
                    print("Exchanges")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Image(systemName: "arrow.2.squarepath")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18, alignment: .center)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.black)

                            Text("Top Exchanges")
                                .fontTemplate(DefaultTemplate.subheadingMedium_black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 10, style: .circular).foregroundColor(Color("softOrange")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))
            }

            // MARK: Top Gainer / Top Losers
            HStack(alignment: .center, spacing: 5) {
                Button(action: {
                    print("Top Gainers")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18, alignment: .center)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.black)

                            Text("Top Gainers")
                                .fontTemplate(DefaultTemplate.subheadingMedium_black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 10, style: .circular).foregroundColor(Color("softGreen")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))

                Button(action: {
                    print("Top Losers")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    HStack(alignment: .center, spacing: 0) {
                        VStack(alignment: .leading, spacing: 5) {
                            Image(systemName: "arrow.down.forward")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 14, height: 14, alignment: .center)
                                .font(Font.title.weight(.light))
                                .foregroundColor(.black)

                            Text("Top Losers")
                                .fontTemplate(DefaultTemplate.subheadingMedium_black)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 10, style: .circular).foregroundColor(Color("softRed")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))
            }

            ListSection(style: service.themeStyle) {
                ListStandardButton(title: "Recently Added", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                    print("Recently Added")
                })

                ListStandardButton(title: "Public Treasury", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                    print("Public Market Treasury")
                })

                ListStandardButton(title: "Rate Us", systemImage: "star", isLast: false, style: service.themeStyle, action: {
                    print("Rate")
                })

                ListStandardButton(title: "Discord", systemImage: "lock", isLast: false, style: service.themeStyle, action: {
                    print("Discord")
                })

                ListStandardButton(title: "Twitter", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                    print("Twitter")
                })
            }

        }
        .padding([.horizontal, .bottom])
    }
}
