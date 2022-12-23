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
                DispatchQueue.main.async {
                    if let gasIndex = self.gasPrices.firstIndex(where: { $0.network == gasPrice.network }) {
                        self.gasPrices[gasIndex] = gasPrice
                    } else {
                        self.gasPrices.append(gasPrice)
                    }

                    print("done getting gas price for \(network): \(gasPrice)")

                    completion()
                }
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
                if let storage = StorageService.shared.globalMarketData {
                    storage.async.setObject(global, forKey: "globalMarketData") { _ in }
                }

                DispatchQueue.main.async {
                    self.globalMarketData = global
                    print("done getting global market data: \(global.activeCryptocurrencies ?? 0)")

                    completion()
                }
            case .failure(let error):
                print("error fetching global market data: \(error)")
                completion()
            }
        }
    }

}
