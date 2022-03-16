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

}
