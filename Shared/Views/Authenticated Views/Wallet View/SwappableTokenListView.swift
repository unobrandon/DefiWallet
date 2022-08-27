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

    @State private var swappableTokens: [SwapToken] = []
    @State private var noMore: Bool = false
    @State var showIndicator: Bool = false
    @State var showSheet: Bool = false
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    private let isSendToken: Bool

    init(isSendToken: Bool, service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
        self.isSendToken = isSendToken
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            NavigationView {
                ScrollView {
                    if swappableTokens.isEmpty, store.accountSendingTokens?.isEmpty ?? true, searchText.isEmpty {
                        Text("no swappable tokens found \n please try reloading and check your connection")
                            .fontTemplate(DefaultTemplate.caption)
                            .multilineTextAlignment(.center)
                            .padding(.vertical)
                    } else if searchText.isEmpty {
                        ListSection(title: "Tokens", style: service.themeStyle) {
                            if let accountTokens = store.accountSendingTokens {
                                ForEach(isSendToken ? accountTokens : accountTokens.filter({ $0.network == store.sendToken?.network }), id: \.self) { item in
                                    if item != store.sendToken {
                                        self.swapToken(nil, item, isLast: swappableTokens.isEmpty && item == accountTokens.last)
                                    }
                                }
                            } else if isSendToken {
                                Text("your wallet does not own any tokens to swap.\n receive tokens to enable swapping")
                                    .fontTemplate(DefaultTemplate.caption)
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical)
                            }

                            if !isSendToken {
                                ForEach(swappableTokens.prefix(limitCells), id: \.self) { item in
                                    if item != store.receiveSwapToken {
                                        self.swapToken(item, nil, isLast: item == swappableTokens.prefix(limitCells).last)
                                    }
                                }
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

            if !isSendToken {
                fetchSwappableTokens()
            }
        }
    }

    private func fetchSwappableTokens() {
        if let storage = StorageService.shared.swappableTokens {
            storage.async.object(forKey: "swappableTokens") { result in
                switch result {
                case .value(let swapList):
                    self.swappableTokens.removeAll()

                    if store.sendToken?.network == "eth",
                       let eth = swapList.eth?.values {
                        for ethToken in eth {
                            self.swappableTokens.append(ethToken)
                        }
                    }

                    if store.sendToken?.network == "polygon",
                       let polygon = swapList.polygon?.values {
                        for polygonToken in polygon {
                            self.swappableTokens.append(polygonToken)
                        }
                    }

                    if store.sendToken?.network == "avax",
                       let avax = swapList.avax?.values {
                        for avaxToken in avax {
                            self.swappableTokens.append(avaxToken)
                        }
                    }

                    if store.sendToken?.network == "bsc",
                       let bnb = swapList.bnb?.values {
                        for bnbToken in bnb {
                            self.swappableTokens.append(bnbToken)
                        }
                    }

                    if store.sendToken?.network == "fantom",
                       let fantom = swapList.fantom?.values {
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

            if isSendToken {
                if tokenModel?.network != store.sendToken?.network {
                    store.receiveToken = nil
                    store.receiveSwapToken = nil
                }

                store.sendToken = tokenModel
                print("selected send: \(tokenModel?.tokenAddress ?? swapToken?.address ?? "none")")
            } else {
                store.receiveToken = tokenModel
                store.receiveSwapToken = swapToken
                print("selected: \(tokenModel?.tokenAddress ?? swapToken?.address ?? "none")")
            }

            walletRouter.popLast()
        }, label: {
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .center, spacing: 10) {
                    ZStack {
                        RemoteImage(swapToken?.logoURI ?? tokenModel?.image ?? tokenModel?.imageSmall ?? "", size: 38)
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(0.8), lineWidth: 1))
                            .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)

                            if let net = tokenModel?.network {
                                Image((net == "bsc" ? "binance" : net) + "_logo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2)))
                                    .offset(x: -14, y: 14)
                            } else if let net2 = store.sendToken?.network {
                                Image((net2 == "bsc" ? "binance" : net2) + "_logo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 15, height: 15, alignment: .center)
                                    .clipShape(Circle())
                                    .overlay(Circle().foregroundColor(.clear).overlay(Circle().stroke(Color("baseBackground_bordered"), lineWidth: 2)))
                                    .offset(x: -14, y: 14)
                            }
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Text(swapToken?.name ?? tokenModel?.name ?? "")
                            .fontTemplate(DefaultTemplate.bodySemibold_nunito)

                        HStack(alignment: .center, spacing: 2) {
                            if let nativeBalance = tokenModel?.nativeBalance {
                                Text(nativeBalance.formatCommas())
                                    .fontTemplate(DefaultTemplate.caption_Mono_secondary)
                            }

                            Text(swapToken?.displayedSymbol?.uppercased() ?? swapToken?.symbol?.uppercased() ?? tokenModel?.symbol?.uppercased() ?? "")
                                .fontTemplate(DefaultTemplate.caption_Mono_secondary)
                        }
                    }
                    Spacer()

                    Image(systemName: "chevron.right")
                        .resizable()
                        .font(Font.title.weight(.semibold))
                        .scaledToFit()
                        .frame(width: 6, height: 12, alignment: .center)
                        .foregroundColor(.secondary)

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
