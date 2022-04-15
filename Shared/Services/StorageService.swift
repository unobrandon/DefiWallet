//
//  StorageService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/20/22.
//

import Foundation
import Cache
import UIKit

class StorageService {

    static var shared: StorageService = StorageService()

    private let storageExpiry = Date().addingTimeInterval(168*3600)

    let diskConfig = DiskConfig(name: "DefiWallet")
    let memoryConfig: MemoryConfig

    var dataStorage: Storage<String, Data>?
    var balanceStorage: Cache.Storage<String, [CompleteBalance]>?
    var nftUriResponse: Cache.Storage<String, NftURIResponse>?
    var historyStorage: Cache.Storage<String, [HistoryData]>?
    var portfolioStorage: Cache.Storage<String, AccountPortfolio>?
    var trendingStorage: Cache.Storage<String, [TrendingCoin]>?
    var gasPriceTrends: Cache.Storage<String, EthGasPriceTrends>?
    var globalMarketData: Cache.Storage<String, GlobalMarketData>?
    var tokenCategories: Cache.Storage<String, [TokenCategory]>?
    var marketCapStorage: Cache.Storage<String, [CoinMarketCap]>?

    init() {
        self.memoryConfig = MemoryConfig(expiry: .date(storageExpiry), countLimit: 50, totalCostLimit: 0)

        do {
            self.dataStorage = try Storage<String, Data>(diskConfig: diskConfig, memoryConfig: memoryConfig, transformer: TransformerFactory.forData())
        } catch {
            print("error getting data storage")
        }

        // balance
        do {
            self.balanceStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: [CompleteBalance].self))
        } catch {
            print(error)
        }

        // history
        do {
            self.historyStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: [HistoryData].self))
        } catch {
            print(error)
        }

        // portfolio
        do {
            self.portfolioStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: AccountPortfolio.self))
        } catch {
            print("error getting Portfolio storage \(error.localizedDescription)")
        }

        // trending
        do {
            self.trendingStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: [TrendingCoin].self))
        } catch {
            print("error getting trending storage \(error.localizedDescription)")
        }

        // gas price trends
        do {
            self.gasPriceTrends = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: EthGasPriceTrends.self))
        } catch {
            print("error getting gas price trends storage \(error.localizedDescription)")
        }

        // market cap
        do {
            self.marketCapStorage = try Storage(diskConfig: diskConfig,
                                              memoryConfig: memoryConfig,
                                              transformer: TransformerFactory.forCodable(ofType: [CoinMarketCap].self))
        } catch {
            print("error getting trending storage \(error.localizedDescription)")
        }

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

        */
    }

}
