//
//  CategoriesDetailView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/2/22.
//

import SwiftUI

struct CategoriesDetailView: View {

    @EnvironmentObject private var marketRouter: MarketsCoordinator.Router
    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    let category: TokenCategory
    let fromWalletView: Bool

    @State private var searchText: String = ""
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State private var limitCells: Int = 25

    init(fromWalletView: Bool? = nil, category: TokenCategory, service: AuthenticatedServices) {
        self.fromWalletView = fromWalletView ?? false
        self.category = category
        self.service = service
        self.store = service.market

        self.store.tokenCategoryList.removeAll()
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView {
                HStack {
                    VStack(alignment: .leading, spacing: 2.5) {
                        if let numCap = category.marketCap,
                           let numVol = category.volume24H {
                            Text("The \(self.category.name ?? "") market cap is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numCap), size: .large)) with a \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numVol), size: .large)) 24 hour volume.")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.description ?? "" != "" ? 0 : 20)
                        } else if let numCap = category.marketCap {
                            Text("The \(self.category.name ?? "") market cap is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numCap), size: .large)).")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.description ?? "" != "" ? 0 : 20)
                        } else if let numVol = category.volume24H {
                            Text("The \(self.category.name ?? "") 24 hour volume is \(Locale.current.currencySymbol ?? "")\("".formatLargeNumber(Int(numVol), size: .large)).")
                                .fontTemplate(DefaultTemplate.bodySemibold)
                                .multilineTextAlignment(.leading)
                                .padding(.bottom, category.description ?? "" != "" ? 0 : 20)
                        }

                        if let description = category.description, !description.isEmpty {
                            ViewMoreText(description)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)

                ListSection(title: !searchText.isEmpty ? "searched tokens" : "\(store.categoriesDetailFilters == .marketCapDesc ? "by top market cap" : store.categoriesDetailFilters == .volume ? "by top volume" : store.categoriesDetailFilters == .id ? "names A-Z" : "")", style: service.themeStyle) {
                    ForEach(store.tokenCategoryList.prefix(limitCells).indices, id: \.self) { index in
                        TokenListStandardCell(service: service, data: store.tokenCategoryList[index],
                                              isLast: false,
                                              style: service.themeStyle, action: {
                            if fromWalletView {
                                walletRouter.route(to: \.tokenDetails, store.tokenCategoryList[index])
                            } else {
                                marketRouter.route(to: \.detailsTokenDetail, store.tokenCategoryList[index])
                                print("the item is: \(store.tokenCategoryList[index].name ?? "no name")")
                            }
                        })
                    }
                }

                RefreshFooter(refreshing: $showIndicator, action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        limitCells += 25
                        withAnimation(.easeInOut) {
                            showIndicator = false
                            noMore = store.tokenCategoryList.count <= limitCells
                        }
                    }
                }, label: {
                    if noMore {
                        FooterInformation()
                    } else {
                        LoadingView(title: "loading...")
                    }
                })
                .noMore(noMore)
                .preload(offset: 50)
            }.enableRefresh()
        })
        .navigationBarTitle(category.name ?? "Category List", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search tokens")
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            fetchTokenCategoriesList()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Section {
                        Button {
                            store.tokenCategoryList.removeAll()
                            withAnimation(.easeInOut) { store.categoriesDetailFilters = .id }
                            self.limitCells = 25
                            self.fetchTokenCategoriesList()
                        } label: {
                            Label("Name", systemImage: store.categoriesDetailFilters == .id ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategoryList.removeAll()
                            withAnimation(.easeInOut) { store.categoriesDetailFilters = .marketCapDesc }
                            self.limitCells = 25
                            self.fetchTokenCategoriesList()
                        } label: {
                            Label("Market Cap", systemImage: store.categoriesDetailFilters == .marketCapDesc ? "checkmark" : "")
                        }

                        Button {
                            store.tokenCategoryList.removeAll()
                            withAnimation(.easeInOut) { store.categoriesDetailFilters = .volume }
                            self.limitCells = 25
                            self.fetchTokenCategoriesList()
                        } label: {
                            Label("Volume", systemImage: store.categoriesDetailFilters == .volume ? "checkmark" : "")
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18, alignment: .center)
                        Text("Sort")
                    }
                }
                .buttonStyle(.borderless)
                .controlSize(.small)
                .buttonBorderShape(.roundedRectangle)
                .buttonStyle(ClickInteractiveStyle(0.99))
            }
        }
    }

    private func fetchTokenCategoriesList() {
        guard let id = category.externalId else { return }
        service.market.fetchCategoryDetails(categoryId: id, currency: service.currentUser.currency)
    }

}
