//
//  MarketsService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI
import Alamofire
import Cache

class MarketsService: ObservableObject {

    @Published var gasPrices = [GasPrice]()
    @Published var ethGasPriceTrends: EthGasPriceTrends?
    @Published var coinsByMarketCap = [CoinMarketCap]()
    @Published var trendingCoins = [TrendingCoin]()

    @Published var isTrendingLoading: Bool = false
    @Published var isMarketCapLoading: Bool = false

    init() {
//        self.fetchEthGasPriceTrends(completion: { print("gas is done loading") })
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
                print("error featching gas price: \(error)")
                completion()
            }
        }
    }

    func fetchEthGasPriceTrends(completion: @escaping () -> Void) {

        let url = Constants.backendBaseUrl + "ethGasTrend"

        AF.request(url, method: .get).responseDecodable(of: EthGasPriceTrends.self) { response in
            switch response.result {
            case .success(let ethGasPriceTrends):
                self.ethGasPriceTrends = ethGasPriceTrends

                completion()
            case .failure(let error):
                print("error featching gas price: \(error)")
                completion()
            }
        }
    }

    func fetchCoinsByMarketCap(currency: String, perPage: Int? = 25, page: Int? = 1, completion: @escaping () -> Void) {
        self.isMarketCapLoading = true

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
        let urlDirect = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=" + currency + "&order=market_cap_desc&per_page=\(perPage ?? 25)" + "&page=\(page ?? 1)" + "&sparkline=false"

        AF.request(urlDirect, method: .get).responseDecodable(of: CoinsByMarketCap.self) { response in
            switch response.result {
            case .success(let marketCapToken):
                if let list = marketCapToken.marketCap {
                    print("coin market cap success: \(list.count)")
                    self.coinsByMarketCap = list
//                    if page == 1 {
//                        self.coinsByMarketCap = list
//                    } else {
//                        self.coinsByMarketCap += list
//                    }

                    if let storage = StorageService.shared.marketCapStorage {
                        storage.async.setObject(list, forKey: "marketCapList") { _ in }
                    }
                }

                completion()

            case .failure(let error):
                print("error loading coin market cap list: \(error)")

                completion()
            }
        }
    }

    func fetchTrending(completion: @escaping () -> Void) {
        self.isTrendingLoading = true

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
