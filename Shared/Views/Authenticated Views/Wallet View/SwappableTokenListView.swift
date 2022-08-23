//
//  SwappableTokenListView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/23/22.
//

import SwiftUI

struct SwappableTokenListView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    var accountSendingTokens: [TokenModel]?

    @State private var swappableTokens: [SwapToken] = []
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State var showSheet: Bool = false
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    init(accountSendingTokens: [TokenModel]?, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.accountSendingTokens = accountSendingTokens ?? nil
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            NavigationView {
                ScrollView {
                    if swappableTokens.isEmpty, accountSendingTokens?.isEmpty ?? true, searchText.isEmpty {
                        Text("no swappable tokens found \n please try reloading and check your connection")
                            .fontTemplate(DefaultTemplate.caption)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                    } else if searchText.isEmpty, !swappableTokens.isEmpty {
                        ListSection(title: "Tokens", style: service.themeStyle) {
                            if let accountTokens = accountSendingTokens {
                                ForEach(accountTokens, id: \.self) { item in
                                    self.swapToken(nil, item, isLast: swappableTokens.isEmpty && item == accountTokens.last)
                                }
                            }

                            ForEach(swappableTokens.prefix(limitCells), id: \.self) { item in
                                self.swapToken(item, nil, isLast: item == swappableTokens.prefix(limitCells).last)
                            }
                        }
                    }

                    RefreshFooter(refreshing: $showIndicator, action: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            limitCells += 25
                            withAnimation(.easeInOut) {
                                showIndicator = false
                                noMore = swappableTokens.count <= limitCells
                            }
                        }
                    }, label: {
                        if searchText.isEmpty, !swappableTokens.isEmpty {
                            if noMore {
                                FooterInformation()
                            } else {
                                LoadingView(title: "loading more...")
                            }
                        }
                    })
                    .noMore(noMore)
                    .preload(offset: 50)
                }
                .enableRefresh()
                .navigationBarTitle("Select Token", displayMode: .inline)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search tokens")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(alignment: .center, spacing: 10) {
                            Button {
                                #if os(iOS)
                                    HapticFeedback.rigidHapticFeedback()
                                #endif

                                walletRouter.popLast()
                            } label: {
                                Text("Done")
                            }
                            .foregroundColor(Color.blue)
                        }
                    }
                }
            }
        })
        .onAppear {
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }

            fetchSwappableTokens()
        }
    }

    private func fetchSwappableTokens() {
        if let storage = StorageService.shared.swappableTokens {
            storage.async.object(forKey: "swappableTokens") { result in
                switch result {
                case .value(let swapList):
                    if let eth = swapList.eth?.values {
                        for ethToken in eth {
                            self.swappableTokens.append(ethToken)
                        }
                    }

                    if let polygon = swapList.polygon?.values {
                        for polygonToken in polygon {
                            self.swappableTokens.append(polygonToken)
                        }
                    }

                    if let avax = swapList.avax?.values {
                        for avaxToken in avax {
                            self.swappableTokens.append(avaxToken)
                        }
                    }

                    if let bnb = swapList.bnb?.values {
                        for bnbToken in bnb {
                            self.swappableTokens.append(bnbToken)
                        }
                    }

                    if let fantom = swapList.fantom?.values {
                        for fantomToken in fantom {
                            self.swappableTokens.append(fantomToken)
                        }
                    }

                    self.swappableTokens = self.swappableTokens.sorted(by: { $0.name?.lowercased() ?? "" < $1.name?.lowercased() ?? "" })
                case .error(let error):
                    print("error getting swappable tokens: \(error.localizedDescription)")
                }
            }
        }
    }

    @ViewBuilder func swapToken(_ swapToken: SwapToken?, _ tokenModel: TokenModel?, isLast: Bool) -> some View {
        Button(action: {
            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif

            DispatchQueue.global().asyncAfter(deadline: .now() + 0.3) {
                walletRouter.popLast()
            }
        }, label: {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    RemoteImage(swapToken?.logoURI ?? tokenModel?.image ?? tokenModel?.imageSmall ?? "", size: 38)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                        .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                    VStack(alignment: .leading, spacing: 0) {
                        Text(swapToken?.name ?? tokenModel?.name ?? "")
                            .fontTemplate(DefaultTemplate.bodySemibold_nunito)

                        Text(swapToken?.displayedSymbol?.uppercased() ?? swapToken?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? "")
                            .fontTemplate(DefaultTemplate.caption_Mono_secondary)
                    }
                    Spacer()

                    if let totalBalance = tokenModel?.totalBalance,
                       totalBalance >= 0.01 {
                        Text(totalBalance.convertToCurrency())
                            .fontTemplate(DefaultTemplate.caption_Mono_secondary)
                    }

                    Circle()
                        .strokeBorder(DefaultTemplate.borderColor, lineWidth: 1.5)
                        .background(Circle().fill(.clear))
                        .frame(width: 16, height: 16)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))

                }.padding(.horizontal)
                .padding(.vertical, 10)

                if !isLast {
                    if service.themeStyle == .shadow {
                        Divider().padding(.leading, 50)
                    } else if service.themeStyle == .border {
                        Rectangle().foregroundColor(DefaultTemplate.borderColor)
                            .frame(height: 1)
                    }
                }
            }
        })
        .buttonStyle(DefaultInteractiveStyle(style: service.themeStyle))
    }

}
