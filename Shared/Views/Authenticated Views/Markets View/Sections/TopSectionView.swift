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
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 20) {
                ListStandardButton(title: "Top Categories", systemImage: "list.number", isLast: false, style: service.themeStyle, action: {
                    print("Currency")
                    marketRouter.route(to: \.categoriesView)
                })
                .background(Color("ethereum"))

                ListStandardButton(title: "New Tokens", systemImage: "newspaper", isLast: false, style: service.themeStyle, action: {
                    print("New Tokens")
                    marketRouter.route(to: \.categoriesView)
                })
                .background(Color("polygon"))
            }

            HStack(alignment: .center, spacing: 10) {
                Button(action: {
                    print("Top Gainers")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 20, alignment: .center)
                            .font(Font.title.weight(.medium))
                            .foregroundColor(.white)

                        Text("Top Gainers")
                            .fontTemplate(DefaultTemplate.sectionHeader_bold_white)
                    }
                    .padding()
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 15, style: .circular).foregroundColor(Color("grassGreen")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))

                Button(action: {
                    print("Top Losers")
                    marketRouter.route(to: \.categoriesView)
                }, label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: "arrow.down.forward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                            .font(Font.title.weight(.medium))
                            .foregroundColor(.white)

                        Text("Top Losers")
                            .fontTemplate(DefaultTemplate.sectionHeader_bold_white)
                    }
                    .padding()
                    .frame(maxWidth: 240)
                    .background(RoundedRectangle(cornerRadius: 15, style: .circular).foregroundColor(Color("alertRed")))
                    .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                })
                .buttonStyle(ClickInteractiveStyle(0.975))
            }
        }
        .padding([.horizontal, .bottom])
    }
}
