//
//  WalletService+Swap.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 8/23/22.
//

import Foundation
import Alamofire

extension WalletService {

    func loadSwappableTokens(completion: @escaping (SwappableTokens?) -> Void) {
        var localResult: SwappableTokens?

        if let storage = StorageService.shared.swappableTokens {
            storage.async.object(forKey: "swappableTokens") { result in
                switch result {
                case .value(let swapList):
                    localResult = swapList
                case .error(let error):
                    print("error getting swappable tokens: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "getSwappableTokens"

        AF.request(url, method: .get).responseDecodable(of: SwappableTokens.self) { response in
            switch response.result {
            case .success(let swapResult):
                if let storage = StorageService.shared.swappableTokens {
                    storage.async.setObject(swapResult, forKey: "swappableTokens") { _ in }
                }

                completion(swapResult)

            case .failure(let error):
                print("error loading swappable tokens: \(error)")

                completion(localResult)
            }
        }
    }

    func getAccountSwappableTokens(_ swappableTokens: SwappableTokens, completion: @escaping ([TokenModel]?) -> Void) {
        var allTokens: [TokenModel] = []

        guard let completeBal = self.accountBalance?.completeBalance else {
            return completion(nil)
        }

        for networkItem in completeBal {
            // Add native network token
            if let nativeToken = networkItem.nativeBalance,
               nativeToken.totalBalance ?? 0 > 0 {
                allTokens.append(nativeToken)
            }

            // Network token
            if let tokens = networkItem.tokens {
                for networkToken in tokens {
                    if networkItem.network == "eth",
                       let eth = swappableTokens.eth,
                       eth.contains(where: { $0.key == networkToken.allAddress?.ethereum }) {
                        allTokens.append(networkToken)
                    }

                    if networkItem.network == "bsc",
                       let bnb = swappableTokens.bnb,
                       bnb.contains(where: { $0.key == networkToken.allAddress?.binance }) {
                        allTokens.append(networkToken)
                    }

                    if networkItem.network == "avalanche",
                       let avax = swappableTokens.avax,
                       avax.contains(where: { $0.key == networkToken.allAddress?.avalanche }) {
                        allTokens.append(networkToken)
                    }

                    if networkItem.network == "polygon", let polygon = swappableTokens.polygon,
                              polygon.contains(where: { $0.key == networkToken.allAddress?.polygon_pos }) {
                        allTokens.append(networkToken)
                    }

                    if networkItem.network == "fantom",
                       let fantom = swappableTokens.fantom,
                       fantom.contains(where: { $0.key == networkToken.allAddress?.polygon_pos }) {
                      allTokens.append(networkToken)
                    }
                }
            }
        }

        completion(allTokens.sorted(by: { $0.totalBalance ?? 0.0 > $1.totalBalance ?? 0.0 }))
    }

}
