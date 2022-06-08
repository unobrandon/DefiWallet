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
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(store.trendingCoins, id: \.self) { data in
                        if let data = data.item {
                            TrendingTokenListCell(service: service, data: data, style: service.themeStyle, action: { item in
                                print("selected the item: \(item.name ?? "")")
                            })
                        }
                    }
                }.marquee(duration: 30, direction: .rightToLeft)
            }
            .overlay(content: {
                HStack {
                    let color = Color("baseBackground")
                    LinearGradient(colors: [color, color.opacity(0.75), color.opacity(0.5), color.opacity(0.01)], startPoint: .leading, endPoint: .trailing)
                        .frame(width: 25)

                    Spacer()
                    LinearGradient(colors: [color, color.opacity(0.75), color.opacity(0.5), color.opacity(0.01)].reversed(), startPoint: .leading, endPoint: .trailing)
                        .frame(width: 25)
                }
            })
            .padding(.bottom, 10)

            // MARK: Top Categories / Exchanges
            HStack(alignment: .center, spacing: 5) {
                Button(action: {
                    print("Top Categories")
                    marketRouter.route(to: \.categoriesView)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
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
                    marketRouter.route(to: \.exchangesView)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
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
                    marketRouter.route(to: \.topGainers)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
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
                    marketRouter.route(to: \.topLosers)

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
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
        }
        .padding([.horizontal, .bottom])
    }
}
