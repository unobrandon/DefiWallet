//
//  SendToView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/27/22.
//

import SwiftUI
import SwiftUIX

struct SendToView: View {

    @EnvironmentObject private var walletRouter: WalletCoordinator.Router

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: WalletService

    @State private var prevAddress: [String] = []
    @State var enableLoadMore: Bool = true
    @State var showIndicator: Bool = false
    @State var showSheet: Bool = false
    @State private var limitCells: Int = 25
    @State private var searchText = ""

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.wallet
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            LoadMoreScrollView(enableLoadMore: $enableLoadMore, showIndicator: $showIndicator, onLoadMore: {
                limitCells += 25
                showIndicator = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showIndicator = false

                    if limitCells < prevAddress.count {
                        enableLoadMore = true
                    }
                }
            }, {
                if prevAddress.isEmpty, searchText.isEmpty {
                    Text("no recent transactions \n search any public address or ENS name")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                } else if searchText.isEmpty, !prevAddress.isEmpty {
                    ListSection(title: "Recents", style: service.themeStyle) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 0) {
                                ForEach(prevAddress.prefix(limitCells).indices, id: \.self) { item in
                                    recentAddressCell(prevAddress[item])
                                }
                            }.padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            })
        })
        .navigationBarTitle("Send To", displayMode: .large)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search public address (0x) or ENS...")
        .onAppear {
            fetchPreviousAddress()
            DispatchQueue.main.async {
                Tool.hiddenTabBar()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(alignment: .center, spacing: 10) {
                    Button {
                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif

                        SOCManager.present(isPresented: $showSheet) {
                            ScanQRView(showSheet: $showSheet, service: service)
                        }
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    .foregroundColor(Color.primary)
                }
            }
        }
    }

    private func fetchPreviousAddress() {
        // loops through the last 500 transactions for the recent sent address =
        for item in self.store.history.filter({ $0.direction == .outgoing }).prefix(500) {
            if let toEthNameService = item.destinationEns, !prevAddress.contains(toEthNameService) {
                prevAddress.append(toEthNameService)
            } else if !prevAddress.contains(item.destination) {
                prevAddress.append(item.destination)
            }
        }
    }

    @ViewBuilder func recentAddressCell(_ address: String) -> some View {
        Button(action: {
            walletRouter.route(to: \.sendToDetail, address)

            #if os(iOS)
                HapticFeedback.rigidHapticFeedback()
            #endif
        }, label: {
            VStack(alignment: .center, spacing: 10) {
                EmptyAvatar(username: address, size: 42, style: service.themeStyle)
                Text(address.formatAddress()).fontTemplate(DefaultTemplate.captionPrimary)
            }
            .padding(.vertical)
            .padding(.horizontal, 5)
            .contentShape(Rectangle())
        })
        .buttonStyle(ClickInteractiveStyle(0.96))
    }

}
