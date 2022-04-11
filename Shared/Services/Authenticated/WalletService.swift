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
    @Published var accountNfts = [NftResult]()
    @Published var history = [HistoryData]()
    @Published var wcProposal: WalletConnect.Session.Proposal?
    @Published var wcActiveSessions = [WCSessionInfo]()

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

    func fetchAccountBalance(_ address: String, completion: @escaping ([CompleteBalance]?) -> Void) {
        let url = Constants.backendBaseUrl + "accountBalance" + "?address=\(address)"

        if let storage = StorageService.shared.balanceStorage {
            storage.async.object(forKey: "balanceList") { result in
                switch result {
                case .value(let balance):
                    self.completeBalance = balance
                case .error(let error):
                    print("error getting local balance: \(error.localizedDescription)")
                }
            }
        }

        AF.request(url, method: .get).responseDecodable(of: AccountBalance.self) { [self] response in
            switch response.result {
            case .success(let accountBalance):
                if let balance = accountBalance.completeBalance {
                    self.completeBalance = balance
                    print("account balance is: \(self.completeBalance.count)")

                    if let storage = StorageService.shared.balanceStorage {
                        storage.async.setObject(balance, forKey: "balanceList") { _ in
                            completion(balance)
                        }
                    }
                }

            case .failure(let error):
                print("error loading balance: \(error)")

                completion(!self.completeBalance.isEmpty ? self.completeBalance : nil)
            }
        }
    }

    func setAccountCollectables(_ completeBalance: [CompleteBalance], completion: @escaping ([NftResult]) -> Void) {
        var result: [NftResult] = []

        for networkBalance in completeBalance {
            guard let nftResult = networkBalance.nfts?.result else { continue }

            for nft in nftResult {
//                var myNft = nft
//                if let networkString = networkBalance.network {
//                    myNft.network = networkString
//                }

                result.append(nft)
            }
        }

        print("called set colletavles")

        completion(result)
    }

    func decodeNftMetadata(_ metadata: String, completion: @escaping (NftURIResponse?) -> Void) {
        let decoder = JSONDecoder()

        do {
            let uriResponse = try decoder.decode(NftURIResponse.self, from: metadata.data(using: .utf8) ?? Data())

            var requestUrl = ""

            if let image_url = uriResponse.image_url {
                if image_url.contains("ipfs://") {
                    let hash = image_url.replacingOccurrences(of: "ipfs://", with: "")
                    let completeHash = hash.replacingOccurrences(of: "image", with: "")
                    requestUrl = Constants.backendBaseUrl + "getIpfsDoc?hash=" + completeHash

                    AF.request(requestUrl, method: .get).responseDecodable(of: NftURIResponse.self, emptyResponseCodes: [200]) { result in
                        switch result.result {
                        case .success(let nftUri):
                            completion(nftUri)
                            print("my downloded nft uri is: \(nftUri)")

                            if let storage = StorageService.shared.nftUriResponse {
                                storage.async.setObject(nftUri, forKey: requestUrl) { _ in }
                            }

                        case .failure(let error):
                            print("error downloading loading nft uri: \(error)")
                        }
                    }

                } else {
                    requestUrl = image_url
                }
            } else {
                requestUrl = uriResponse.image ?? ""
            }

            var result = uriResponse
            result.image = requestUrl

            completion(result)
        } catch {
            completion(nil)
        }
    }

    func fetchNftUri(_ url: String, response: @escaping (NftURIResponse) -> Void) {

        if let storage = StorageService.shared.nftUriResponse {
            storage.async.object(forKey: url) { result in
                switch result {
                case .value(let nftUri):
                    print("my nft uri is: \(nftUri)")
//                    response(nftUri)
                case .error(_ ):
                    print("error")
                }
            }
        }

        var requestUrl = ""

        print("the url requested is: \(url)")
        if url.contains("ipfs://") {
            let hash = url.replacingOccurrences(of: "ipfs://", with: "")
            let completeHash = hash.replacingOccurrences(of: "image", with: "")

            requestUrl = Constants.backendBaseUrl + "getIpfsDoc?hash=" + completeHash
        } else {
            requestUrl = url
        }

        AF.request(requestUrl, method: .get).responseDecodable(of: NftURIResponse.self, emptyResponseCodes: [200]) { result in
            switch result.result {
            case .success(let nftUri):
                response(nftUri)

                if let storage = StorageService.shared.nftUriResponse {
                    storage.async.setObject(nftUri, forKey: url) { _ in }
                }

            case .failure(let error):
                print("error loading nft uri: \(error)")
            }
        }
    }

    func fetchHistory(_ address: String, completion: @escaping () -> Void) {

        // Good ETH address to test with: 0x660c6f9ff81018d5c13ab769148ec4db4940d01c
        let url = Constants.zapperBaseUrl + "transactions?address=\(address)&addresses%5B%5D=\(address)&" + Constants.zapperApiKey

        if let storage = StorageService.shared.historyStorage {
            storage.async.object(forKey: "historyList") { result in
                switch result {
                case .value(let history):
                    self.history = history
                case .error(let error):
                    print("error getting local history: \(error.localizedDescription)")
                }
            }
        }

        AF.request(url, method: .get).responseDecodable(of: TransactionHistory.self, emptyResponseCodes: [200]) { response in
            switch response.result {
            case .success(let history):
                if let history = history.data {
                    self.history = history
                    print("history count is: \(history.count)")

                    if let storage = StorageService.shared.historyStorage {
                        storage.async.setObject(history, forKey: "historyList") { result in
                            switch result {
                            case .value(let val):
                                print("saved history successfully: \(val)")

                            case .error(let error):
                                print("error saving history locally: \(error)")
                            }
                        }
                    }
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

    func getNetworkEnum(_ network: String) -> Network {
        if network == "eth" { return .ethereum
        } else if network == "polygon" { return .polygon
        } else if network == "bsc" { return .binanceSmartChain
        } else if network == "avalanche" { return .avalanche
        } else if network == "fantom" { return .fantom
        } else { return .ethereum }
    }

    func getBlockExplorerName(_ network: Network) -> String {
        switch network {
        case .ethereum:
            return "Etherscan.io"
        case .polygon:
            return "Polygonscan.com"
        case .binanceSmartChain:
            return "Bscscan.com"
        case .avalanche:
            return "Snowtrace.io"
        case .fantom:
            return "Ftmscan.com"
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

    // Remove this. Not good logic.
    func getNetworkTotal(_ completeBalance: CompleteBalance) -> String {
        guard let tokens = completeBalance.tokenBalance else { return "0.00" }
        var total: Double = 0.00

        for token in tokens {
            if let usdTotal = token.usdTotal, let balance = Double(usdTotal) {
                total += balance
            }
        }

        return "\(total)"
    }

    func shareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

}
