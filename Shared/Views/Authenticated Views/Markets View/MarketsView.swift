//
//  MarketsView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import SwiftUIX
import Stinsen

struct MarketsView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: MarketsService

    @State var searchText: String = ""
    @State var searchHide: Bool = true

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.market
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                Text("It's the market view!!")
            }
        })
        .navigationTitle("Market")
        .navigationSearchBar {
            SearchBar("Search tokens and more...", text: $searchText)
        }
        .navigationSearchBarHiddenWhenScrolling(searchHide)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        print("gas")
                    } label: {
                        Image(systemName: "fuelpump.fill")
                    }
                    .foregroundColor(Color.primary)

                    Button {
                        self.searchHide.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }

}
