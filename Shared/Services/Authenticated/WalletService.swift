//
//  WalletService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI
import Alamofire
import WalletConnect
import Relayer

class WalletService: ObservableObject {
    // Wallet view functions go here

    @Published var accountBalance = [AccountBalance]()
    @Published var completeBalance = [CompleteBalance]()
    @Published var accountNfts = [AccountNft]()
    @Published var history = [HistoryData]()
    @Published var wcProposal: WalletConnect.Session.Proposal?
    @Published var wcActiveSessions = [WCSessionInfo]()

    @Published var isHistoryLoading: Bool = false

    var currentUser: CurrentUser
    var walletConnectClient: WalletConnectClient

    init(currentUser: CurrentUser) {
        self.currentUser = currentUser

        let metadata = AppMetadata(name: Constants.projectName,
                                   description: "Difi Wallet App", url: "defi.wallet",
                                   icons: [Constants.walletConnectMetadataIcon])
        let relayer = Relayer(relayHost: "relay.walletconnect.com", projectId: Constants.walletConnectProjectId)

        self.walletConnectClient = WalletConnectClient(metadata: metadata, relayer: relayer)
        self.walletConnectClient.delegate = self
        self.reloadActiveSessions()

        self.fetchHistory(currentUser.wallet.address, completion: {
            self.isHistoryLoading = false
        })
    }

    func connectDapp(uri: String, completion: @escaping (Bool) -> Void) {
        do {
            try self.walletConnectClient.pair(uri: uri)

            DispatchQueue.main.async { completion(true) }
        } catch {
            DispatchQueue.main.async { completion(false) }
        }
    }

    func disconnectDapp(sessionTopic: String) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.walletConnectClient.disconnect(topic: sessionTopic, reason: Reason(code: 0, message: "User disconnected from \(Constants.projectName)"))

            self.reloadActiveSessions()
            HapticFeedback.successHapticFeedback()
        }
    }

    func viewDappWebsite(link: String) {
        print("visit dapp's website: \(link)")
    }

    func fetchAccountBalance(_ address: String, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "accountBalance" + "?address=\(address)"

        AF.request(url, method: .get).responseDecodable(of: AccountBalance.self) { response in
            switch response.result {
            case .success(let accountBalance):
                if let balance = accountBalance.completeBalance {
                    self.completeBalance = balance
                    print("account balance is: \(self.completeBalance.count)")
                }

                completion()

            case .failure(let error):
                print("error loading balance: \(error)")

                completion()
            }
        }
    }

    func fetchHistory(_ address: String, completion: @escaping () -> Void) {

        // Good ETH address to test with: 0x660c6f9ff81018d5c13ab769148ec4db4940d01c
        let url = Constants.zapperBaseUrl + "transactions?address=\(address)&addresses%5B%5D=\(address)&" + Constants.zapperApiKey
        isHistoryLoading = true

        AF.request(url, method: .get).responseDecodable(of: TransactionHistory.self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let history):
                if let historyData = history.data {
                    self.history = historyData
                    print("history count is: \(self.history.count)")
                }

                completion()

            case .failure(let error):
                print("error loading history: \(error)")

                completion()
            }
        }
    }

    func transactionImage(_ direction: Direction) -> String {
        switch direction {
        case .incoming:
            return "arrow.down"
        case .outgoing:
            return "paperplane.fill"
        case .exchange:
            return "arrow.left.arrow.right"
        }
    }

    func transactionColor(_ direction: Direction) -> Color {
        switch direction {
        case .incoming:
            return Color.green
        case .outgoing:
            return Color.red
        case .exchange:
            return Color.blue
        }
    }

    func getNetworkImage(_ network: Network) -> Image {
        switch network {
        case .ethereum:
            return Image("eth_logo")
        case .polygon:
            return Image("polygon_logo")
        case .binanceSmartChain:
            return Image("binance_logo")
        case .avalanche:
            return Image("avalanche_logo")
        case .fantom:
            return Image("fantom_logo")
        }
    }

    func getNetworkColor(_ network: String) -> Color {
        if network == "eth" { return Color("ethereum")
        } else if network == "polygon" { return Color("polygon")
        } else if network == "bsc" { return Color("binance")
        } else if network == "avalanche" { return Color("avalanche")
        } else if network == "fantom" { return Color("fantom")
        } else { return Color.primary }
    }

    func getBlockExplorerName(_ network: Network) -> String {
        switch network {
        case .ethereum:
            return "Etherscan"
        case .polygon:
            return "Polygonscan"
        case .binanceSmartChain:
            return "Bscscan"
        case .avalanche:
            return "Snowtrace"
        case .fantom:
            return "Ftmscan"
        }
    }

    func getScannerUrl(_ network: Network) -> String {
        switch network {
        case .ethereum:
            return "https://etherscan.io/tx/"
        case .polygon:
            return "https://polygonscan.com/tx/"
        case .binanceSmartChain:
            return "https://www.bscscan.com/tx/"
        case .avalanche:
            return "https://snowtrace.io/tx/"
        case .fantom:
            return "https://ftmscan.com/tx/"
        }
    }

    func shareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

}
