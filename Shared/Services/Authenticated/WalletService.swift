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

    func fetchHistory(_ address: String, completion: @escaping () -> Void) {
        // Good ETH address to test with: 0x660c6f9ff81018d5c13ab769148ec4db4940d01c

        let url = "https://api.zapper.fi/v1/transactions?address=0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9&addresses%5B%5D=0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9&api_key=96e0cc51-a62e-42ca-acee-910ea7d2a241"

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
