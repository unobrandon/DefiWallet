//
//  DiscoverView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import SwiftUIX
import Stinsen

struct DiscoverView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: DiscoverService

    @State private var searchText: String = ""
    @State private var placeholderItems: [String] = ["welcomeCarouselThree", "gradientBg1", "gradientBg2", "gradientBg3"]

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
            }
        })
        .navigationTitle("Discover")
        .navigationSearchBar { SearchBar("Search all web3...", text: $searchText) }
        .navigationSearchBarHiddenWhenScrolling(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                Button {
//                    print("search")
//                } label: {
//                    Image(systemName: "magnifyingglass")
//                }
//                .foregroundColor(Color.primary)
//            }
//        }
    }

}
