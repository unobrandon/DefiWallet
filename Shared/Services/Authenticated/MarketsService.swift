//
//  MarketsService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI
import Alamofire

class MarketsService: ObservableObject {

    @Published var gasPrices = [GasPrice]()
    @Published var ethGasPriceTrends: EthGasPriceTrends?
    @Published var coinsByMarketCap = [CoinMarketCap]()

    @Published var isMarketCapLoading: Bool = false

    init() {
        self.fetchEthGasPriceTrends(completion: { print("gas is done loading") })
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

        let url = Constants.backendBaseUrl + "topCoinsByMarketCap" + "?currency=" + currency + "&perPage=\(perPage ?? 25)" + "&page=\(page ?? 1)"
//        let urlDirect = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=" + currency + "&order=market_cap_desc&per_page=\(perPage ?? 25)" + "&page=\(page ?? 1)" + "&sparkline=false"

        AF.request(url, method: .get).responseDecodable(of: CoinsByMarketCap.self) { response in
            switch response.result {
            case .success(let marketCapToken):
                print("coin market cap: \(marketCapToken)")

                if let list = marketCapToken.marketCap {
                    if page == 1 {
                        self.coinsByMarketCap = list
                    } else {
                        self.coinsByMarketCap += list
                    }
                }

                completion()

            case .failure(let error):
                print("error loading coin market cap list: \(error)")

                completion()
            }
        }
    }

}
