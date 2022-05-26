//
//  DiscoverView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI

struct DiscoverView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: DiscoverService

    @State private var searchText: String = ""
    @State private var placeholderItems: [String] = ["welcomeCarouselThree", "gradientBg1", "gradientBg2", "gradientBg3"]
    @State var loadingLearn: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.discover
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                ACarousel(placeholderItems, id: \.self, spacing: 20, headspace: 20,
                          sidesScaling: 1.0, isWrap: false, autoScroll: .active(6)) { item in
                    Image(item)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 160)
                        .cornerRadius(30)
                        .shadow(color: .black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 12, x: 0, y: 6)
                        .offset(y: -10)
                }.frame(height: 200)

                Text("Here will be: \n- List of exchanges -> details (https://api.coingecko.com/api/v3/exchanges/) \n- List of market indexes (https://api.coingecko.com/api/v3/indexes) \n- List of btc & eth public company's treasury (https://api.coingecko.com/api/v3/companies/public_treasury/bitcoin)")
                    .fontTemplate(DefaultTemplate.caption)

                NewsBlogSection(isLoading: $loadingLearn, service: service)
            }
        })
        .navigationBarTitle("Discover", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search all web3...")
    }

}
