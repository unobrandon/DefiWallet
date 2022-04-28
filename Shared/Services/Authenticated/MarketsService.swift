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
    @Published var coinsByMarketCap = [CoinMarketCap]()
    @Published var trendingCoins = [TrendingCoin]()

    var socketManager: SocketManager
    var gasSocket: SocketIOClient
    var gasSocketTimer: Timer?

    let gasRefreshInterval: Double = 10
    var gasChartLimit: Int = 24

    init(socketManager: SocketManager) {
        self.socketManager = socketManager
        self.gasSocket = socketManager.socket(forNamespace: "/gas")

        connectGasSocket()
    }

    private func connectGasSocket() {
        gasSocket.connect()

        gasSocket.on(clientEvent: .connect) { _, _ in
            self.fetchGasSocket()
        }

        gasSocket.on(clientEvent: .disconnect) { _, _ in
            self.stopGasTimer()
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

    func fetchTokenCategories(completion: @escaping () -> Void) {
        if let storage = StorageService.shared.tokenCategories {
            storage.async.object(forKey: "tokenCategories") { result in
                switch result {
                case .value(let categories):
                    print("got categories!! \(categories)")

                    DispatchQueue.main.async {
                        self.tokenCategories = categories
                    }
                case .error(let error):
                    print("error getting tokenCategories: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "topCategories"

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
                completion()
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

        func listCountriesAndCurrencies() {
            let localeIds = Locale.availableIdentifiers
            var countryCurrency = [String: String]()
            for localeId in localeIds {
                let locale = Locale(identifier: localeId)

                if let country = locale.regionCode {
                    if let currency = locale.currencySymbol {
                        countryCurrency[country] = currency
                    }
                }
            }

            let sorted = countryCurrency.keys.sorted()
            for country in sorted {
                let currency = countryCurrency[country]!

                print("country: \(country), currency: \(currency)")
            }
        }

        listCountriesAndCurrencies()

//        let url = Constants.backendBaseUrl + "topCoinsByMarketCap" + "?currency=" + currency + "&perPage=\(perPage ?? 25)" + "&page=\(page ?? 1)"
        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=" + currency + "&order=market_cap_desc&per_page=\(perPage ?? 25)" + "&page=\(page ?? 1)" + "&sparkline=true&price_change_percentage=24h"

        AF.request(url, method: .get).responseDecodable(of: [CoinMarketCap].self) { response in
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
