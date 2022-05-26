//
//  MarketsService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI
import Alamofire
import Cache
import SocketIO

class MarketsService: ObservableObject {

    @Published var gasPrices = [GasPrice]()
    @Published var gasSocketPrices: GasSocketPrice?
    @Published var ethGasPriceTrends: EthGasPriceTrends?
    @Published var globalMarketData: GlobalMarketData?
    @Published var tokenCategories = [TokenCategory]()
    @Published var exchanges = [ExchangeModel]()
    @Published var coinsByMarketCap = [TokenDetails]()
    @Published var tokenCategoryList = [TokenDetails]()
    @Published var trendingCoins = [TrendingCoin]()

    var socketManager: SocketManager
    var gasSocket: SocketIOClient
    var assetSocket: SocketIOClient
    var gasSocketTimer: Timer?

    let gasRefreshInterval: Double = 10
    var gasChartLimit: Int = 24

    init(socketManager: SocketManager) {
        self.socketManager = socketManager
        self.gasSocket = socketManager.socket(forNamespace: "/gas")
        self.assetSocket = socketManager.socket(forNamespace: "/assets")

        connectSockets()
    }

    private func connectSockets() {
        gasSocket.connect()
        assetSocket.connect()

        gasSocket.on(clientEvent: .connect) { _, _ in
            self.fetchGasSocket()
        }

        gasSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopGasTimer()
        }

        assetSocket.on(clientEvent: .connect) { _, _ in
            self.fetchAssetsSocket()
        }
    }

    func disconnectAccountSocket() {
        gasSocket.disconnect()
        gasSocket.removeAllHandlers()
    }

    func stopGasTimer() {
        guard let timer = gasSocketTimer else { return }
        timer.invalidate()
    }

    private func fetchGasSocket() {

        self.gasSocketTimer = Timer.scheduledTimer(withTimeInterval: gasRefreshInterval, repeats: true) { _ in
            self.gasSocket.emit("get", ["scope": ["price"], "payload": ["body parameter": "value"]])
        }

        gasSocket.on("received gas price") { data, _ in
            guard let array = data as? [[String: AnyObject]],
                  let firstDict = array.first,
                  let payload = firstDict["payload"],
                  let prices = payload["price"] as? [String: AnyObject] else { return }

            guard let source = prices["source"] as? String,
                  let datetime = prices["datetime"] as? String,
                  let fast = prices["fast"] as? Double,
                  let standard = prices["standard"] as? Double,
                  let slow = prices["slow"] as? Double else { return }

            print("the standard gas is: \(standard)")
            DispatchQueue.main.async {
                self.gasSocketPrices = GasSocketPrice(source: source, datetime: datetime, rapid: prices["rapid"] as? Double, fast: fast, standard: standard, slow: slow)
            }
        }
    }

    private func fetchAssetsSocket() {

        assetSocket.on("received assets categories") { data, ack in
            DispatchQueue.main.async {
                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                    let asset = firstDict["payload"]! as! [String: AnyObject]
                    print("received assets categories value is: \(asset)")
                }
            }
        }

        assetSocket.on("received assets full-info") { data, _ in
            guard let array = data as? [[String: AnyObject]],
                  let firstDict = array.first,
                  let payload = firstDict["payload"] as? [String: AnyObject],
                  let fullInfo = payload["full-info"] as? [String: AnyObject],
                  let asset = fullInfo["asset"] as? [String: AnyObject] else { return }

//            guard let assetCode = asset["asset_code"] as? String,
//                  let decimals = asset["decimals"] as? Int,
//                  let iconUrl = asset["icon_url"] as? String,
//                  let isDisplayable = asset["is_displayable"] as? Int,
//                  let isVerified = asset["is_verified"] as? Int,
//                  let tokenName = asset["name"] as? String,
//                  let symbol = asset["symbol"] as? String,
//                  let circulatingSupply = payload["circulating_supply"] as? Double,
//                  let description = payload["description"] as? String else { return }

            DispatchQueue.main.async {
//                if let array = data as? [[String: AnyObject]], let firstDict = array.first {
//                    let payloaddd = firstDict["payload"]! as! [String: AnyObject]
                print("that payload: \(asset)! && received assets full-info value is: \(asset["name"]) \n\(fullInfo)")
//                }
            }
        }

    }

    func emitFullInfoAssetSocket(_ assetCode: String, currency: String) {
        assetSocket.emit("get", ["scope": ["full-info"], "payload": ["asset_code": assetCode, "currency": currency]])
        print("sent the emit \(assetCode)")
    }

    func sortGas(_ network: Network) -> GasPrice? {
        return self.gasPrices.first(where: { $0.network == network })
    }

    func fetchGasPrice(_ network: Network, completion: @escaping () -> Void) {

        let url = Constants.backendBaseUrl + "gas" + "?network=\(network.rawValue)"

        AF.request(url, method: .get).responseDecodable(of: GasPrice.self) { response in
            switch response.result {
            case .success(let gasPrice):
                if let gasIndex = self.gasPrices.firstIndex(where: { $0.network == gasPrice.network }) {
                    self.gasPrices[gasIndex] = gasPrice
                } else {
                    self.gasPrices.append(gasPrice)
                }

                print("done getting gas price for \(network): \(gasPrice)")

                completion()
            case .failure(let error):
                print("error fetching gas price: \(error)")
                completion()
            }
        }
    }

    func fetchGlobalMarketData(completion: @escaping () -> Void) {
        if let storage = StorageService.shared.globalMarketData {
            storage.async.object(forKey: "globalMarketData") { result in
                switch result {
                case .value(let global):
                    print("got global market data locally")
                    DispatchQueue.main.async {
                        self.globalMarketData = global
                    }
                case .error(let error):
                    print("error getting global market data locally: \(error.localizedDescription)")
                }
            }
        }

         let url = Constants.backendBaseUrl + "global"
//        let url = "https://api.coingecko.com/api/v3/global"

        AF.request(url, method: .get).responseDecodable(of: GlobalMarketData.self) { response in
            switch response.result {
            case .success(let global):
                DispatchQueue.main.async {
                    self.globalMarketData = global
                }
                print("done getting global market data: \(global)")

                if let storage = StorageService.shared.globalMarketData {
                    storage.async.setObject(global, forKey: "globalMarketData") { _ in }
                }

                completion()
            case .failure(let error):
                print("error fetching global market data: \(error)")
                completion()
            }
        }
    }

    func fetchEthGasPriceTrends(completion: @escaping () -> Void) {
        if let storage = StorageService.shared.gasPriceTrends {
            storage.async.object(forKey: "gasPriceTrends") { result in
                switch result {
                case .value(let trends):
                    print("got eth gas price trends")
                    DispatchQueue.main.async {
                        self.ethGasPriceTrends = trends
                    }
                case .error(let error):
                    print("error getting eth gas price trends: \(error.localizedDescription)")
                }
            }
        }

        // let url = Constants.backendBaseUrl + "ethGasTrend"
        let url = "https://api.zapper.fi/v1/gas-price/trend?network=ethereum&api_key=96e0cc51-a62e-42ca-acee-910ea7d2a241"

        AF.request(url, method: .get).responseDecodable(of: EthGasPriceTrends.self) { response in
            switch response.result {
            case .success(let ethGasPriceTrends):
                DispatchQueue.main.async {
                    self.ethGasPriceTrends = ethGasPriceTrends
                }

                if let storage = StorageService.shared.gasPriceTrends {
                    storage.async.setObject(ethGasPriceTrends, forKey: "gasPriceTrends") { _ in }
                }

                completion()
            case .failure(let error):
                print("error fetching gas price: \(error)")
                completion()
            }
        }
    }

    func fetchTokenCategories(filter: FilterCategories, limit: Int, skip: Int, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "fetchCategories?order=" + filter.rawValue + "&queryLimit=\(limit)" + "&querySkip=\(skip)"
//        let url = "https://api.coingecko.com/api/v3/coins/categories?order=" + filter.rawValue

        AF.request(url, method: .get).responseDecodable(of: [TokenCategory].self) { response in
            switch response.result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.tokenCategories = categories
                }
                print("got categories network!! \(categories.count)")

                if let storage = StorageService.shared.tokenCategories {
                    storage.async.setObject(categories, forKey: "tokenCategories") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting tokenCategories network: \(error)")
                if let storage = StorageService.shared.tokenCategories {
                    storage.async.object(forKey: "tokenCategories" + filter.rawValue) { result in
                        switch result {
                        case .value(let categories):
                            print("got categories!! \(categories)")

                            DispatchQueue.main.async {
                                self.tokenCategories = categories
                                completion()
                            }
                        case .error(let error):
                            print("error getting tokenCategories: \(error.localizedDescription)")
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchCategoryDetails(categoryId: String, currency: String, page: Int? = 1) {

        if let storage = StorageService.shared.marketCapStorage {
            storage.async.object(forKey: "categoryList\(categoryId)\(page ?? 1)") { result in
                switch result {
                case .value(let list):
                    print("got local category List")
                    DispatchQueue.main.async {
                        self.tokenCategoryList = list
                    }
                case .error(let error):
                    print("error getting local category List: \(error.localizedDescription)")
                    self.tokenCategoryList.removeAll()
                }
            }
        }

        let baseUrl = "https://api.coingecko.com/api/v3/coins/markets"
        let filteredSection = "?vs_currency=" + currency + "&category=" + categoryId
        let lastSection = "&order=market_cap_desc&per_page=50&page=\(page ?? 1)&sparkline=true"

        AF.request(baseUrl + filteredSection + lastSection, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.tokenCategoryList = categories
                }
                print("got categories tokens!! \(categories.count)")

                if let storage = StorageService.shared.marketCapStorage {
                    storage.async.setObject(categories, forKey: "categoryList\(categoryId)\(page ?? 1)") { _ in }
                }

            case .failure(let error):
                print("error getting token categories list: \(error)")
            }
        }
    }

    func fetchTopExchanges(limit: Int, skip: Int, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "topExchanges?skip=\(skip)" + "&limit=\(limit)"

        AF.request(url, method: .get).responseDecodable(of: [ExchangeModel].self) { response in
            switch response.result {
            case .success(let exchanges):
                DispatchQueue.main.async {
                    self.exchanges = exchanges
                }
                print("got exchanges!! \(exchanges.count)")

                if let storage = StorageService.shared.topExchanges {
                    storage.async.setObject(exchanges, forKey: "topExchanges") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api exchanges: \(error)")
                if let storage = StorageService.shared.topExchanges {
                    storage.async.object(forKey: "tokenCategories") { result in
                        switch result {
                        case .value(let exchanges):
                            print("got local exchanges!! \(exchanges)")

                            DispatchQueue.main.async {
                                self.exchanges = exchanges
                                completion()
                            }
                        case .error(let error):
                            print("error getting exchanges: \(error.localizedDescription)")
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchCoinsByMarketCap(currency: String, perPage: Int? = 25, page: Int? = 1, completion: @escaping () -> Void) {

        if let storage = StorageService.shared.marketCapStorage {
            storage.async.object(forKey: "marketCapList") { result in
                switch result {
                case .value(let list):
                    print("got local coin market cap")
                    DispatchQueue.main.async {
                        self.coinsByMarketCap = list
                    }
                case .error(let error):
                    print("error getting local market cap: \(error.localizedDescription)")
                }
            }
        }

//        let url = Constants.backendBaseUrl + "topCoinsByMarketCap" + "?currency=" + currency + "&perPage=\(perPage ?? 25)" + "&page=\(page ?? 1)"
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=" + currency + "&order=market_cap_desc&per_page=\(perPage ?? 25)" + "&page=\(page ?? 1)" + "&sparkline=true&price_change_percentage=24h"

        AF.request(url, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let marketCapToken):
                print("coin market cap success: \(marketCapToken.count)")

                if page == 1 {
                    self.coinsByMarketCap = marketCapToken
                } else {
                    self.coinsByMarketCap += marketCapToken
                }

                if let storage = StorageService.shared.marketCapStorage {
                    storage.async.setObject(marketCapToken, forKey: "marketCapList") { _ in }
                }

                completion()

            case .failure(let error):
                print("error loading coin market cap list: \(error)")

                completion()
            }
        }
    }

    func fetchTokenDetails(id: String?, address: String?, completion: @escaping (TokenDescriptor?) -> Void) {
        guard id != nil || address != nil else {
            completion(nil)
            return
        }

        var url: String {
            if let id = id {
                return Constants.backendBaseUrl + "getTokenId?id=" + id
            } else if let address = address {
                return Constants.backendBaseUrl + "getTokenByAddress?address=" + address
            } else { return "" }
        }

        print("the url to find the token details is: \(url.debugDescription)")

        AF.request(url, method: .get).responseDecodable(of: TokenDescriptor.self) { response in
            switch response.result {
            case .success(let token):

                if let storage = StorageService.shared.tokenDescriptor {
                    storage.async.setObject(token, forKey: "tokenDetails\(id ?? address ?? "")") { _ in }
                }

                DispatchQueue.main.async {
                    completion(token)
                }
                print("done getting token details data: \(String(describing: token.name))")

            case .failure(let error):
                print("error fetching global market data: \(error)")
                if let storage = StorageService.shared.tokenDescriptor {
                    storage.async.object(forKey: "tokenDetails\(id ?? address ?? "")") { result in
                        switch result {
                        case .value(let token):
                            print("got token details data locally")
                            completion(token)
                        case .error(let error):
                            print("error getting token data locally: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    func fetchTokenChart(id: String, from: Date, toDate: Date, completion: @escaping ([ChartValue]?) -> Void) {
        let url = Constants.backendBaseUrl + "getTokenByIdChart?tokenId=" + id + "&from=\(Int(from.timeIntervalSince1970))" + "&to=\(Int(toDate.timeIntervalSince1970))"

        print("the url to find the token chart is: \(url.debugDescription)")

        AF.request(url, method: .get).responseDecodable(of: [ChartValue].self) { response in
            switch response.result {
            case .success(let chart):
                if let storage = StorageService.shared.tokenCharts {
                    storage.async.setObject(chart, forKey: "tokenCharts\(id)") { _ in }
                }
                print("done getting token chart data \(chart)")

                DispatchQueue.main.async {
                    completion(chart)
                }

            case .failure(let error):
                print("error fetching chart data: \(error)")
                if let storage = StorageService.shared.tokenCharts {
                    storage.async.object(forKey: "tokenCharts\(id)") { result in
                        switch result {
                        case .value(let token):
                            completion(token)
                        case .error(let error):
                            print("error getting token chart locally: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    func fetchTrending(completion: @escaping () -> Void) {
        if let storage = StorageService.shared.trendingStorage {
            storage.async.object(forKey: "trendingList") { result in
                switch result {
                case .value(let list):
                    print("got local trending tokens")
                    self.trendingCoins = list
                case .error(let error):
                    print("error getting local trending tokens: \(error.localizedDescription)")
                }
            }
        }

//        let url = Constants.backendBaseUrl + "trending"
        let urlDirect = "https://api.coingecko.com/api/v3/search/trending"

        AF.request(urlDirect, method: .get).responseDecodable(of: TrendingCoins.self) { response in
            switch response.result {
            case .success(let trending):
                if let list = trending.coins {
                    print("trending coins success: \(list.count)")
                    self.trendingCoins = list

                    if let storage = StorageService.shared.trendingStorage {
                        storage.async.setObject(list, forKey: "trendingList") { result in
                            switch result {
                            case .value(let val):
                                print("saved trending coins successfully: \(val)")

                            case .error(let error):
                                print("error saving: \(error)")
                            }
                        }
                    }
                }

                completion()

            case .failure(let error):
                print("error loading trending list: \(error)")

                completion()
            }
        }
    }

}
