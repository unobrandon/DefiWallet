//
//  WalletService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI
import Alamofire

class WalletService: ObservableObject {
    // Wallet view functions go here

    @Published var history = [Datum]()
    @Published var accountBalance = [ChainBalance]()
    @Published var accountNfts = [NetworkNfts]()

    func fetchChainBalances(_ address: String, completion: @escaping () -> Void) {

        let url = Constants.backendBaseUrl + "accountCompleteBalance" + "?address=\(address)"

        AF.request(url, method: .get).responseDecodable(of: AccountBalance.self) { response in
            switch response.result {
            case .success(let accountBalance):
                if let chains = accountBalance.chainBalance {
                    self.accountBalance = chains
                }
                print("chainBalance count is: \(self.accountBalance.count)")

                completion()

            case .failure(let error):
                print("error loading history: \(error)")

                completion()
            }
        }
    }

    func fetchAccountNfts(_ address: String, completion: @escaping () -> Void) {

        let url = Constants.backendBaseUrl + "accountNfts" + "?address=\(address)"

        AF.request(url, method: .get).responseDecodable(of: AccountNfts.self) { response in
            switch response.result {
            case .success(let accountBalance):
                if let networks = accountBalance.networkNfts {
                    self.accountNfts = networks
                }
                print("NFT count is: \(self.accountNfts.count)")

                completion()

            case .failure(let error):
                print("error loading history: \(error)")

                completion()
            }
        }
    }

    func fetchHistory(_ address: String, completion: @escaping () -> Void) {

        // Good ETH address to test with: 0x660c6f9ff81018d5c13ab769148ec4db4940d01c
        let url = Constants.zapperBaseUrl + "transactions?address=\(address)&addresses%5B%5D=\(address)&" + Constants.zapperApiKey

        AF.request(url, method: .get).responseDecodable(of: TransactionHistory.self) { response in
            switch response.result {
            case .success(let history):
                if let historyData = history.data {
                    self.history = historyData
                    print("history count is: \(self.history.count)")
                }

                completion()

            case .failure(let error):
                print("error loading history: \(error)")

                completion()
            }
        }
    }

    func fetchCustomGas(completion: @escaping () -> Void) {

        AF.request("https://defiwallet-backend.herokuapp.com/gas", method: .get).responseDecodable(of: GasPrice.self) { response in
            switch response.result {
            case .success(let gas):
                print("gas is: \(gas.standardGas)")

                completion()

            case .failure(let error):
                print("error loading gas: \(error)")

                completion()
            }
        }
    }

}
