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

    @Published var testInt: Int = 0

    @Published var history = [Datum]()

    func fetchHistory(_ address: String, completion: @escaping () -> Void) {
        let url = "https://api.zapper.fi/v1/transactions?address=0x660c6f9ff81018d5c13ab769148ec4db4940d01c&addresses%5B%5D=0x660c6f9ff81018d5c13ab769148ec4db4940d01c&api_key=96e0cc51-a62e-42ca-acee-910ea7d2a241"

        AF.request(url, method: .get).responseDecodable(of: TransactionHistory.self) { response in
            switch response.result {
            case .success(let history):
                if let historyData = history.data {
                    self.history = historyData
                }

                completion()

            case .failure(let error):
                print("error loading history: \(error)")

                completion()
            }
        }
    }

}
