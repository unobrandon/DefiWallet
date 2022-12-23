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
    @Published var isLoadingPortfolioChart: Bool = false

    @Published var accountSendingTokens: [TokenModel]?
    @Published var sendToken: TokenModel?
    @Published var receiveToken: TokenModel?
    @Published var receiveSwapToken: SwapToken?
    @Published var tokenDetailChart: [[Double]]?
    @Published var tokenDetailPrice: Double?

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
    @Published var swapResult: SwapTokens?

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
                    storage.async.setObject(accountBalance, forKey: "balanceList") { _ in }
                }

                completion(self.accountBalance?.completeBalance)

            case .failure(let error):
                print("error loading balance: \(error)")

                completion(!(self.accountBalance?.completeBalance?.isEmpty ?? true) ? self.accountBalance?.completeBalance : nil)
            }
        }
    }

    // MARK: Logic for overall portfolio chart

    // Need 2 primary timelines to create the new overall timeline

    // get each token's historical chart data
    // get each token's portfolio diversity

    // get historical timeline for each token when it comes in and out
    // also check if the token's IN transaction is within the required timeline

    // create new 'chart token model'
        /// - tokenId
        /// - tokenChart
        /// - tokenHistory
        /// - tokenNetwork
        /// - token portfolio diversity - but need to check this for every timeline point incase other tokens come or go

    // blank loop through the timeline array count
    // - have newChart variable

    // Start looping from how much you currently have and subtract amount every time historical transaction comes up.

    // loop through each 'chart token model'
        /// - get the history IN & OUTs + token amounts
        /// - create func that finds token amount you had at that one point in time.

    func gatherLocalAccountTokens(completion: @escaping (String?) -> Void) {
        // here we get the local data to formate to send to backend & return the complete chart
        guard let portfolio = self.accountBalance?.completeBalance else {
            completion(nil)
            return
        }

        var newChart: [String] = []

        for network in portfolio {
            // start with all current native tokens & other tokens
            if let external = network.nativeBalance?.externalId,
               let diversity = network.nativeBalance?.portfolioDiversity?.replacingOccurrences(of: "%", with: ""),
               Double(diversity) ?? 0.0 >= 0.25 {
                newChart.append(external)
            }

            if let tokens = network.tokens {
                for token in tokens {
                    if let external = token.externalId,
                       let diversity = token.portfolioDiversity?.replacingOccurrences(of: "%", with: ""),
                       Double(diversity) ?? 0.0 >= 0.25 {
                        newChart.append(external)
                    }
                }
            }
        }

        guard let chartData = try? JSONEncoder().encode(newChart) else {
            completion(nil)
            return
        }

        completion(String(data: chartData, encoding: .utf8))
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
        var totalChange = 0.0
        var totalPercentChange = 0.0

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
                            let tokenBalance = balance * currentPrice
                            self?.accountBalance?.completeBalance?[network].tokens?[token].totalBalance = tokenBalance
                            newTotal += tokenBalance
                            totalChange += ((newPrice.priceChange24H ?? 0.0) * (tokenBalance / (self?.accountBalance?.portfolioTotal ?? 0.0)))
                            totalPercentChange += ((newPrice.priceChangePercentage24h ?? 0.0) * (tokenBalance / (self?.accountBalance?.portfolioTotal ?? 0.0)))
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
                        let tokenBalance = balance * currentPrice
                        self?.accountBalance?.completeBalance?[network].nativeBalance?.totalBalance = tokenBalance
                        newTotal += tokenBalance
                        totalChange += ((newPrice.priceChange24H ?? 0.0) * (tokenBalance / (self?.accountBalance?.portfolioTotal ?? 0.0)))
                        totalPercentChange += ((newPrice.priceChangePercentage24h ?? 0.0) * (tokenBalance / (self?.accountBalance?.portfolioTotal ?? 0.0)))
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
            self?.accountBalance?.portfolio24hChange = totalChange
            self?.accountBalance?.portfolio24hPercentChange = totalPercentChange
            print("the new account total is: \(overallTotal) portfolio change: \(totalChange) & percent change: \(totalPercentChange)")
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

    func shareSheet(url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
    }

}
