//
//  ContentView.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var general = GeneralViewModel()

    var body: some View {
        HStack(spacing: 0) {
            NavigationView {
                // Note: Can not set 'min/maxWidth'. Set it in the content view.
                SideNavigationBar(general: general)

                ZStack {
                    switch general.selectedTab {
                    case "Wallet": WalletViewMac()
                    case "Discover": Text("Discover")
                    case "Markets": Text("Markets")
                    case "Swap": Text("Swap")
                    case "Dapps": Text("Dapps")
                    case "Settings": Text("Settings")
                    default : Text("")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color("bgColor"))
                .animation(.none)
            }
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: toggleSidebar, label: {
                        Image(systemName: "sidebar.leading")
                    })
                }
            }
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: MacConstants.screenWidth / 1.5, maxHeight: MacConstants.screenHeight / 1.5)
        .frame(minWidth: 650, minHeight: 200)
        .frame(idealWidth: 1050, idealHeight: 950)
    }

    private func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WalletViewMac: View {
    @ObservedObject private var store: WalletService = WalletService()

    var body: some View {
        VStack {
            ForEach(store.history, id: \.self) { item in
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text(item.direction == .incoming ? "Received" : item.direction == .outgoing ? "Sent" : "Exchange")
                            .fontTemplate(DefaultTemplates.subheading)

                        if let fromAddress = item.fromEns == nil ? item.from : item.fromEns {
                            Text("from: " + "\("".formatAddress(fromAddress))")
                                .fontTemplate(DefaultTemplates.caption)
                        }
                    }

                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(item.timeStamp.getFullElapsedInterval())")
                            .fontTemplate(DefaultTemplates.caption)

                        Text("\(item.symbol) \(item.amount)")
                            .fontTemplate(DefaultTemplates.body)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.secondary.opacity(0.2)))
                .padding(.horizontal)
            }
        }
        .onAppear {
            store.fetchHistory("0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9", completion: {
                print("done with history")
            })
        }
    }
}
