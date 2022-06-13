//
//  MarketsService+GlobalGas.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 6/12/22.
//

import Foundation
import Alamofire

extension MarketsService {

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

}
