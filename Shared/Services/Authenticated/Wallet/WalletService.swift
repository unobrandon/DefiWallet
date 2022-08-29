//
//  WalletService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI
import Combine
import Alamofire
import WalletConnect
import Relayer
import SocketIO

class WalletService: ObservableObject {

    @Published var accountPortfolio: AccountPortfolio?
    @Published var accountBalance: AccountBalance?
    @Published var accountChart = [ChartValue]()
    @Published var history = [HistoryData]()

    @Published var accountSendingTokens: [TokenModel]?
    @Published var sendToken: TokenModel?
    @Published var receiveToken: TokenModel?
    @Published var receiveSwapToken: SwapToken?

//    @Published var wcProposal: WalletConnect.Session.Proposal?
    @Published var wcActiveSessions = [WCSessionInfo]()
    @Published var networkStatus: NetworkStatus {
        didSet {
            switch networkStatus {
            case .offline:
                print("offline network status")
            case .connected:
                print("connected network status")
            case .connecting:
                print("connecting status")
            case .reconnecting:
                print("re-connecting status")
            case .unknown:
                print("unknown network status")
            }
        }
    }
    @Published var sendTokenAmount: String = ""
    @Published var disablePrimaryAction: Bool = true
    @Published var isLoadingSwapAction: Bool = false
    @Published var swapQuote: SwapQuote?

//    let relayer = Relayer(relayHost: "relay.walletconnect.com", projectId: Constants.walletConnectProjectId)

    var currentUser: CurrentUser
    var socketManager: SocketManager
//    var walletConnectClient: WalletConnectClient
    var addressSocket: SocketIOClient
//    var compoundSocket: SocketIOClient

    let portfolioRefreshInterval: Double = 15
    var chartType: String = UserDefaults.standard.string(forKey: "chartType") ?? "d"
    var accountSocketTimer: Timer?
    var compoundSocketTimer: Timer?
    var loadSwapCancellable: AnyCancellable?

    init(currentUser: CurrentUser, socketManager: SocketManager, wcMetadata: AppMetadata) {
        self.networkStatus = .connecting
        self.currentUser = currentUser

        self.socketManager = socketManager
        self.addressSocket = socketManager.socket(forNamespace: "/address")
//        self.compoundSocket = socketManager.socket(forNamespace: "/compound")
//        self.walletConnectClient = WalletConnectClient(metadata: wcMetadata, relayer: relayer)
//        self.walletConnectClient.delegate = self

        self.loadStoredData()
        self.connectAccountData()
//        self.connectCompoundData()

        loadSwapCancellable = $sendTokenAmount
            .removeDuplicates()
            .debounce(for: 1.0, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                guard let amount = Double(str), amount > 0,
                      self.sendToken != nil, (self.receiveToken != nil || self.receiveSwapToken != nil) else {
                    self.disablePrimaryAction = true
                    self.isLoadingSwapAction = false
                    self.swapQuote = nil
                    return
                }

                let decimalMultiplier = self.receiveToken?.decimals?.decimalToNumber() ?? self.receiveSwapToken?.decimals?.decimalToNumber() ?? Int(Constants.eighteenDecimal)
                let newAmount = amount * Double(decimalMultiplier)

                guard !(newAmount.isNaN || newAmount.isInfinite) else {
                     return
                 }

                self.isLoadingSwapAction = true
                self.disablePrimaryAction = true
                self.getSwapQuote(amount: "\(Int(newAmount))", completion: { result, error in
                    print("done updating swap quote2222. result: \(String(describing: result)) && error: \(String(describing: error))")
                    if error != nil {
                        self.disablePrimaryAction = true
                        self.swapQuote = nil
                    } else {
                        self.disablePrimaryAction = false
                        self.swapQuote = result
                    }
                    self.isLoadingSwapAction = false
                })
            })
    }

    deinit {
        print("de-init wallet service!")
    }

    private func loadStoredData() {

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

        if let storage = StorageService.shared.portfolioStorage {
            storage.async.object(forKey: "portfolio") { result in
                switch result {
                case .value(let portfolio):
                    DispatchQueue.main.async {
                        self.accountPortfolio = portfolio
                    }
                case .error(let error):
                    print("error getting local portfolio: \(error.localizedDescription)")
                }
            }
        }

        if let storage = StorageService.shared.chartStorage {
            let type = UserDefaults.standard.string(forKey: "chartType") ?? self.chartType
            self.chartType = type

            storage.async.object(forKey: "portfolioChart\(type)") { result in
                switch result {
                case .value(let chart):
                    DispatchQueue.main.async {
                        self.accountChart = chart
                    }
                case .error(let error):
                    print("error getting local chart: \(error.localizedDescription)")
                }
            }
        }

    }

    func fetchAccountBalance(_ address: String, _ currency: String, completion: @escaping ([CompleteBalance]?) -> Void) {

        if let storage = StorageService.shared.balanceStorage {
            storage.async.object(forKey: "balanceList") { result in
                switch result {
                case .value(let balance):
                    DispatchQueue.main.async {
                        self.accountBalance = balance
                    }
                case .error(let error):
                    print("error getting local balance: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "accountBalance" + "?address=\(address)" + "&currency=\(currency)"

        AF.request(url, method: .get).responseDecodable(of: AccountBalance.self) { [self] response in
            switch response.result {
            case .success(let accountBalance):
                DispatchQueue.main.async {
                    self.accountBalance = accountBalance
                }

                if let storage = StorageService.shared.balanceStorage {
                    storage.async.setObject(accountBalance, forKey: "balanceList") { _ in
                        completion(self.accountBalance?.completeBalance)
                    }
                }

            case .failure(let error):
                print("error loading balance: \(error)")

                completion(!(self.accountBalance?.completeBalance?.isEmpty ?? true) ? self.accountBalance?.completeBalance : nil)
            }
        }
    }

    func getTokenIds() -> [String] {
        var allTokenIds: [String] = []

        guard let completeBalance = self.accountBalance?.completeBalance else { return [] }

        for network in completeBalance {
            if let externalId = network.nativeBalance?.externalId {
                allTokenIds.append(externalId)
            }

            guard let tokens = network.tokens else { continue }

            for token in tokens {
                if let externalId = token.externalId {
                    allTokenIds.append(externalId)
                }
            }
        }

        return allTokenIds
    }

    func updateAccountBalancePrices(_ prices: [TokenPricesModel]) {
        var overallTotal = 0.0

        guard let completeBalance = self.accountBalance?.completeBalance else { return }

        for network in completeBalance.indices {
            guard let networkTokens = completeBalance[network].tokens else { continue }
            var newTotal = 0.0

            for token in networkTokens.indices {
//                print("the token netwo id is: \(completeBalance[network].tokens?[token])")
                if let index = prices.firstIndex(where: { $0.externalId == completeBalance[network].tokens?[token].externalId }) {
                    DispatchQueue.main.async { [weak self] in
                        let newPrice = prices[index]
                        self?.accountBalance?.completeBalance?[network].tokens?[token].currentPrice = newPrice.currentPrice
                        self?.accountBalance?.completeBalance?[network].tokens?[token].marketCap = newPrice.marketCap
                        self?.accountBalance?.completeBalance?[network].tokens?[token].fullyDilutedValuation = newPrice.fullyDilutedValuation
                        self?.accountBalance?.completeBalance?[network].tokens?[token].high24H = newPrice.high24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].low24H = newPrice.low24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChange24H = newPrice.priceChange24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChangePercentage24H = newPrice.priceChangePercentage24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].marketCapChange24H = newPrice.marketCapChange24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].marketCapChangePercentage24H = newPrice.marketCapChangePercentage24H
                        self?.accountBalance?.completeBalance?[network].tokens?[token].circulatingSupply = newPrice.circulatingSupply
                        self?.accountBalance?.completeBalance?[network].tokens?[token].totalSupply = newPrice.totalSupply
                        self?.accountBalance?.completeBalance?[network].tokens?[token].maxSupply = newPrice.maxSupply
                        self?.accountBalance?.completeBalance?[network].tokens?[token].athChangePercentage = newPrice.athChangePercentage
                        self?.accountBalance?.completeBalance?[network].tokens?[token].athDate = newPrice.athDate
                        self?.accountBalance?.completeBalance?[network].tokens?[token].atlChangePercentage = newPrice.atlChangePercentage
                        self?.accountBalance?.completeBalance?[network].tokens?[token].atlDate = newPrice.atlDate
                        self?.accountBalance?.completeBalance?[network].tokens?[token].lastUpdated = newPrice.lastUpdated
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceGraph = newPrice.priceGraph
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChangePercentage1h = newPrice.priceChangePercentage1h
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChangePercentage24h = newPrice.priceChangePercentage24h
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChangePercentage7d = newPrice.priceChangePercentage7d
                        self?.accountBalance?.completeBalance?[network].tokens?[token].priceChangePercentage1y = newPrice.priceChangePercentage1y
                        if let currentPrice = newPrice.currentPrice,
                           let balance = self?.accountBalance?.completeBalance?[network].tokens?[token].nativeBalance {
                            self?.accountBalance?.completeBalance?[network].tokens?[token].totalBalance = (balance * currentPrice)
                            newTotal += (balance * currentPrice)
                        }
                    }

                }
            }

            if let index = prices.firstIndex(where: { $0.externalId == completeBalance[network].nativeBalance?.externalId }) {
                DispatchQueue.main.async { [weak self] in
                    let newPrice = prices[index]
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.currentPrice = newPrice.currentPrice
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.marketCap = newPrice.marketCap
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.fullyDilutedValuation = newPrice.fullyDilutedValuation
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.high24H = newPrice.high24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.low24H = newPrice.low24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChange24H = newPrice.priceChange24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChangePercentage24H = newPrice.priceChangePercentage24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.marketCapChange24H = newPrice.marketCapChange24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.marketCapChangePercentage24H = newPrice.marketCapChangePercentage24H
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.circulatingSupply = newPrice.circulatingSupply
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.totalSupply = newPrice.totalSupply
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.maxSupply = newPrice.maxSupply
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.athChangePercentage = newPrice.athChangePercentage
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.athDate = newPrice.athDate
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.atlChangePercentage = newPrice.atlChangePercentage
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.atlDate = newPrice.atlDate
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.lastUpdated = newPrice.lastUpdated
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceGraph = newPrice.priceGraph
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChangePercentage1h = newPrice.priceChangePercentage1h
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChangePercentage24h = newPrice.priceChangePercentage24h
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChangePercentage7d = newPrice.priceChangePercentage7d
                    self?.accountBalance?.completeBalance?[network].nativeBalance?.priceChangePercentage1y = newPrice.priceChangePercentage1y
                    if let currentPrice = newPrice.currentPrice,
                       let balance = self?.accountBalance?.completeBalance?[network].nativeBalance?.nativeBalance {
                        self?.accountBalance?.completeBalance?[network].nativeBalance?.totalBalance = (balance * currentPrice)
                        newTotal += (balance * currentPrice)
                    }
                }

            }

            DispatchQueue.main.async { [weak self] in
                overallTotal += newTotal
                self?.accountBalance?.completeBalance?[network].totalBalance = newTotal
            }

        }

        DispatchQueue.main.async { [weak self] in
            self?.accountBalance?.portfolioTotal = overallTotal
            print("the new account total is: \(overallTotal)")
        }

        if let storage = StorageService.shared.balanceStorage, let completeBalance = self.accountBalance {
            storage.async.setObject(completeBalance, forKey: "balanceList") { _ in }
        }
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
                    response(nftUri)
                case .error:
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

        AF.request(url, method: .get).responseDecodable(of: ZapperTransactionHistory.self, emptyResponseCodes: [200]) { response in
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

    func transactionDirectionImage(_ direction: TransactionDirection) -> String {
        switch direction {
        case .received:
            return "arrow.down"
        case .sent:
            return "paperplane.fill"
        case .swap:
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

    func transactionDirectionColor(_ direction: TransactionDirection) -> Color {
        switch direction {
        case .received:
            return Color.green
        case .sent:
            return Color.red
        case .swap:
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

    func getNetworkTransactImage(_ network: String) -> Image {
        if network == "eth" {
            return Image("eth_logo")
        } else if network == "polygon" {
            return Image("polygon_logo")
        } else if network == "bsc" {
            return Image("binance_logo")
        } else if network == "avalanche" {
            return Image("avalanche_logo")
        } else if network == "fantom" {
            return Image("fantom_logo")
        } else {
            return Image("")
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

    func getNetworkNumber(_ network: String) -> String {
        if network == "eth" { return "1"
        } else if network == "polygon" { return "137"
        } else if network == "bsc" { return "56"
        } else if network == "avalanche" { return "43114"
        } else if network == "fantom" { return "250"
        } else { return "" }
    }

    func getChartDuration(_ timePeriod: String) -> String {
        if timePeriod == "h" { return "last hour"
        } else if timePeriod == "d" { return "last 24 hours"
        } else if timePeriod == "w" { return "last 7 days"
        } else if timePeriod == "m" { return "last 30 days"
        } else if timePeriod == "y" { return "last 12 months"
        } else { return "" }
    }

    func getBlockExplorerName(_ network: String) -> String {
        if network == "eth" {
            return "Etherscan.io"
        } else if network == "polygon" {
            return "Polygonscan.com"
        } else if network == "bsc" {
            return "Bscscan.com"
        } else if network == "avalanche" {
            return "Snowtrace.io"
        } else if network == "fantom" {
            return "Ftmscan.com"
        } else {
            return ""
        }
    }

    func getScannerUrl(_ network: String) -> String {
        if network == "eth" {
            return "https://etherscan.io/tx/"
        } else if network == "polygon" {
            return "https://polygonscan.com/tx/"
        } else if network == "bsc" {
            return "https://www.bscscan.com/tx/"
        } else if network == "avalanche" {
            return "https://snowtrace.io/tx/"
        } else if network == "fantom" {
            return "https://ftmscan.com/tx/"
        } else {
            return ""
        }
    }

    // Remove this. Not good logic.
    func getNetworkTotal(_ completeBalance: CompleteBalance) -> Double? {
        if completeBalance.network == "eth" {
            return accountPortfolio?.ethereumAssetsValue
        } else if completeBalance.network == "bsc" {
            return accountPortfolio?.bscAssetsValue
        } else if completeBalance.network == "polygon" {
            return accountPortfolio?.polygonAssetsValue
        } else if completeBalance.network == "avalanche" {
            return accountPortfolio?.avalancheAssetsValue
        } else if completeBalance.network == "fantom" {
            return accountPortfolio?.fantomAssetsValue
        } else if completeBalance.network == "solana" {
            return accountPortfolio?.solanaAssetsValue
        } else {
            return 0.00
        }
    }

    func shareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

}
