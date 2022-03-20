//
//  WalletService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import SwiftUI
import Alamofire
import WalletConnect
import Relayer

class WalletService: ObservableObject {
    // Wallet view functions go here

    @Published var accountBalance = [AccountBalance]()
    @Published var completeBalance = [CompleteBalance]()
    @Published var accountNfts = [AccountNft]()
    @Published var history = [Datum]()
    @Published var walletConnectProposal: WalletConnect.Session.Proposal?

    var walletConnectClient: WalletConnectClient

    init() {
        print("the wallet connect id: \(Constants.walletConnectProjectId)")
        let metadata = AppMetadata(name: Constants.projectName,
            description: "Difi Wallet App", url: "defi.wallet",
            icons: ["https://play.google.com/store/apps/details?id=com.jndapp.cartoon.crayon.iconpack&hl=en_US&gl=US"])
        let relayer = Relayer(relayHost: "relay.walletconnect.com", projectId: Constants.walletConnectProjectId)

        self.walletConnectClient = WalletConnectClient(metadata: metadata, relayer: relayer)

        self.walletConnectClient.delegate = self
    }

    func connectDapp(uri: String, completion: @escaping (Bool) -> Void) {
        do {
            try self.walletConnectClient.pair(uri: uri)

            DispatchQueue.main.async { completion(true) }
        } catch {
            DispatchQueue.main.async { completion(false) }
        }
    }

    func fetchAccountBalance(_ address: String, completion: @escaping () -> Void) {

        let url = Constants.backendBaseUrl + "accountBalance" + "?address=\(address)"

        AF.request(url, method: .get).responseDecodable(of: AccountBalance.self) { response in
            switch response.result {
            case .success(let accountBalance):
                if let balance = accountBalance.completeBalance {
                    self.completeBalance = balance
                    print("account balance is: \(self.completeBalance.count)")
                }

                completion()

            case .failure(let error):
                print("error loading balance: \(error)")

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

}
