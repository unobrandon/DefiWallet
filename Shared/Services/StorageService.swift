//
//  StorageService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/20/22.
//

import Foundation
import Cache

class StorageService {

    static var shared: StorageService = StorageService()

    private let storageExpiry = Date().addingTimeInterval(168*3600)

//    let diskConfig: DiskConfig
    let memoryConfig: MemoryConfig

    var historyStorage: Cache.Storage<String, TransactionHistory>?

    init() {
        self.memoryConfig = MemoryConfig(expiry: .date(storageExpiry), countLimit: 50, totalCostLimit: 0)

        /*
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: true).appendingPathComponent("MyPreferences")

            self.diskConfig = DiskConfig(name: "DefiStorage",
                                         expiry: .date(storageExpiry),
                                         maxSize: 10000,
                                         directory: documentsDirectory,
                                         protectionType: .complete)
        } catch {
            self.diskConfig = DiskConfig(name: "AppStorage",
                                         expiry: .date(storageExpiry),
                                         maxSize: 10000,
                                         directory: nil,
                                         protectionType: .complete)
        }

        // history
        do {
            self.historyStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: TransactionHistory.self))
        } catch {
            print(error)
        }
        */

    }

    func getHistory() {
        guard let history = historyStorage else { return }

        history.async.object(forKey: "history") { result in
            switch result {
            case .value(let user):
                print(user.data ?? "")
            case .error(let error):
                print(error)
            }
        }
    }

}
