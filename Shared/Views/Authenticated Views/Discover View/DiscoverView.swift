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

    @State var searchText: String = ""

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.discover
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                Text("It's the Discover view!!")
            }
        })
        .navigationTitle("Discover")
        .navigationSearchBar {
            SearchBar("Search all web3...", text: $searchText)
        }
        .navigationSearchBarHiddenWhenScrolling(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("search")
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .foregroundColor(Color.primary)
            }
        }
    }

}
