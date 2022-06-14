//
//  MarketsService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import SwiftUI
import Combine
import Alamofire
import Cache
import SocketIO

class MarketsService: ObservableObject {

    @Published var gasPrices = [GasPrice]()
    @Published var gasSocketPrices: GasSocketPrice?
    @Published var ethGasPriceTrends: EthGasPriceTrends?
    @Published var globalMarketData: GlobalMarketData?
    @Published var tokenCategories = [TokenCategory]()
    @Published var exchanges = [ExchangeModel]()
    @Published var exchangeDetails: ExchangeDetails?
    @Published var coinsByMarketCap = [TokenDetails]()
    @Published var coinsByGains = [TokenDetails]()
    @Published var coinsByLosers = [TokenDetails]()
    @Published var recentlyAddedTokens = [TokenDetails]()
    @Published var publicTreasury: PublicTreasury?
    @Published var tokenCategoryList = [TokenDetails]()
    @Published var trendingCoins = [TrendingCoin]()

    var socketManager: SocketManager
    var gasSocket: SocketIOClient
    var assetSocket: SocketIOClient
    var gasSocketTimer: Timer?

    let gasRefreshInterval: Double = 10
    var gasChartLimit: Int = 24

    @Published var searchCategoriesText: String = ""
    @Published var categoriesFilters: FilterCategories = .marketCapDesc
    var categoriesCancellable: AnyCancellable?

    @Published var searchExchangesText: String = ""
    var exchangesCancellable: AnyCancellable?

    init(socketManager: SocketManager) {
        self.socketManager = socketManager
        self.gasSocket = socketManager.socket(forNamespace: "/gas")
        self.assetSocket = socketManager.socket(forNamespace: "/assets")

        categoriesCancellable = $searchCategoriesText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                guard !str.isEmpty else {
//                    self.fetchTokenCategories(filter: self.categoriesFilters, limit: 25, skip: 0, completion: {   })
                    return
                }

                self.searchTokenCategories(text: str, limit: 10, skip: 0)
            })

        exchangesCancellable = $searchExchangesText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                guard !str.isEmpty else {
//                    self.fetchTokenCategories(filter: self.categoriesFilters, limit: 25, skip: 0, completion: {   })
                    return
                }

//                self.searchTokenCategories(text: str, limit: 10, skip: 0)
            })

        connectSockets()
    }

    func fetchTokenCategories(filter: FilterCategories, limit: Int, skip: Int, completion: @escaping () -> Void) {

        if let storage = StorageService.shared.tokenCategories {
            storage.async.object(forKey: "tokenCategories" + filter.rawValue) { result in
                switch result {
                case .value(let categories):
                    print("got categories!! \(categories)")

                    DispatchQueue.main.async {
                        self.tokenCategories = categories
                    }
                case .error(let error):
                    print("error getting tokenCategories: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "fetchCategories?order=" + filter.rawValue + "&queryLimit=\(limit)" + "&querySkip=\(skip)"
//        let url = "https://api.coingecko.com/api/v3/coins/categories?order=" + filter.rawValue

        AF.request(url, method: .get).responseDecodable(of: [TokenCategory].self) { response in
            switch response.result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.tokenCategories = categories
                }
                print("got categories network!! \(categories.count)")

                if let storage = StorageService.shared.tokenCategories {
                    storage.async.setObject(categories, forKey: "tokenCategories"  + filter.rawValue) { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting tokenCategories network: \(error)")
            }
        }
    }

    func searchTokenCategories(text: String, limit: Int, skip: Int) {
        let url = Constants.backendBaseUrl + "searchCategories?text=" + text + "&limit=\(limit)" + "&skip=\(skip)"

        AF.request(url, method: .get).responseDecodable(of: [TokenCategory].self) { response in
            switch response.result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.tokenCategories = categories
                }

                print("got categories!! \(categories.count)")
            case .failure(let error):
                print("error getting tokenCategories network: \(error)")
            }
        }
    }

    func fetchCategoryDetails(categoryId: String, currency: String, page: Int? = 1) {

        if let storage = StorageService.shared.marketCapStorage {
            storage.async.object(forKey: "categoryList\(categoryId)\(page ?? 1)") { result in
                switch result {
                case .value(let list):
                    print("got local category List")
                    DispatchQueue.main.async {
                        self.tokenCategoryList = list
                    }
                case .error(let error):
                    print("error getting local category List: \(error.localizedDescription)")
                    self.tokenCategoryList.removeAll()
                }
            }
        }

        let baseUrl = "https://api.coingecko.com/api/v3/coins/markets"
        let filteredSection = "?vs_currency=" + currency + "&category=" + categoryId
        let lastSection = "&order=market_cap_desc&per_page=50&page=\(page ?? 1)&sparkline=true"

        AF.request(baseUrl + filteredSection + lastSection, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let categories):
                DispatchQueue.main.async {
                    self.tokenCategoryList = categories
                }
                print("got categories tokens!! \(categories.count)")

                if let storage = StorageService.shared.marketCapStorage {
                    storage.async.setObject(categories, forKey: "categoryList\(categoryId)\(page ?? 1)") { _ in }
                }

            case .failure(let error):
                print("error getting token categories list: \(error)")
            }
        }
    }

    func fetchTopExchanges(limit: Int, skip: Int, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "topExchanges?skip=\(skip)" + "&limit=\(limit)"

        if let storage = StorageService.shared.topExchanges {
            storage.async.object(forKey: "topExchanges\(skip)") { result in
                switch result {
                case .value(let exchanges):
                    print("got local exchanges!! \(exchanges)")

                    DispatchQueue.main.async {
                        self.exchanges += exchanges
                    }
                case .error(let error):
                    print("error getting exchanges: \(error.localizedDescription)")
                }
            }
        }

        AF.request(url, method: .get).responseDecodable(of: [ExchangeModel].self) { response in
            switch response.result {
            case .success(let exchanges):
                DispatchQueue.main.async {
                    self.exchanges += exchanges
                }
                print("got exchanges!! \(exchanges.count)")

                if let storage = StorageService.shared.topExchanges {
                    storage.async.setObject(exchanges, forKey: "topExchanges\(skip)") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api exchanges: \(error)")
            }
        }
    }

    func fetchExchangeDetails(_ exchangeId: String, chartDays: Int, page: Int) {
        guard exchangeDetails?.tickers?.first?.market?.identifier != exchangeId else {
            print("exchange details are the same no need to get new detail model")

            return
        }

        exchangeDetails = nil

        if let storage = StorageService.shared.exchangeDetails {
            storage.async.object(forKey: "exchangeDetails\(exchangeId)\(page)") { result in
                switch result {
                case .value(let list):
                    DispatchQueue.main.async {
                        self.exchangeDetails = list
                    }
                case .error(let error):
                    print("error getting local exchangeDetail List: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "fetchExchangeDetails?exchangeId=\(exchangeId)&days=\(chartDays)&page=\(page)"

        AF.request(url, method: .get).responseDecodable(of: ExchangeDetails.self) { response in
            switch response.result {
            case .success(let exchangeDetails):
                DispatchQueue.main.async {
                    self.exchangeDetails = exchangeDetails
                }
                print("got exchange details ticker count: \(String(describing: exchangeDetails.tickers?.count))")

                if let storage = StorageService.shared.exchangeDetails {
                    storage.async.setObject(exchangeDetails, forKey: "exchangeDetails\(exchangeId)\(page)") { _ in }
                }

            case .failure(let error):
                print("error getting exchange details ticker list: \(error)")
            }
        }
    }

    func fetchCoinsByMarketCap(currency: String, perPage: Int? = 25, page: Int? = 1, completion: @escaping () -> Void) {

        if let storage = StorageService.shared.marketCapStorage {
            storage.async.object(forKey: "marketCapList") { result in
                switch result {
                case .value(let list):
                    print("got local coin market cap")
                    DispatchQueue.main.async {
                        self.coinsByMarketCap = list
                    }
                case .error(let error):
                    print("error getting local market cap: \(error.localizedDescription)")
                }
            }
        }

        let url = Constants.backendBaseUrl + "topCoinsByMarketCap" + "?currency=" + currency + "&perPage=\(perPage ?? 25)" + "&page=\(page ?? 1)"
//        let url = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=" + currency + "&order=market_cap_desc&per_page=\(perPage ?? 25)" + "&page=\(page ?? 1)" + "&sparkline=true&price_change_percentage=24h"

        AF.request(url, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let marketCapToken):
                print("coin market cap success: \(marketCapToken.count)")

                if page == 1 {
                    self.coinsByMarketCap = marketCapToken
                } else {
                    self.coinsByMarketCap += marketCapToken
                }

                if let storage = StorageService.shared.marketCapStorage {
                    storage.async.setObject(marketCapToken, forKey: "marketCapList") { _ in }
                }

                completion()

            case .failure(let error):
                print("error loading coin market cap list: \(error)")

                completion()
            }
        }
    }

    func fetchTopGainers(currency: String, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "topCoinsByGainsOrLoss?currency=\(currency)" + "&gainOrLoss=gains"

        AF.request(url, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let gainers):
                DispatchQueue.main.async {
                    self.coinsByGains += gainers
                }
                print("got top gainers!! \(gainers.count)")

                if let storage = StorageService.shared.topGainersOrLosers {
                    storage.async.setObject(gainers, forKey: "topGainers") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api top gainers: \(error)")
                if let storage = StorageService.shared.topGainersOrLosers {
                    storage.async.object(forKey: "topGainers") { result in
                        switch result {
                        case .value(let gainers):
                            print("got local gainers!! \(gainers)")

                            DispatchQueue.main.async {
                                self.coinsByGains += gainers
                                completion()
                            }
                        case .error(let error):
                            print("error getting gainers: \(error.localizedDescription)")
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchTopLosers(currency: String, completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "topCoinsByGainsOrLoss?currency=\(currency)" + "&gainOrLoss=loss"

        AF.request(url, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let losers):
                DispatchQueue.main.async {
                    self.coinsByLosers += losers
                }
                print("got top losers!! \(losers.count)")

                if let storage = StorageService.shared.topGainersOrLosers {
                    storage.async.setObject(losers, forKey: "topLosers") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api top losers: \(error)")
                if let storage = StorageService.shared.topGainersOrLosers {
                    storage.async.object(forKey: "topLosers") { result in
                        switch result {
                        case .value(let losers):
                            print("got local losers!! \(losers)")

                            DispatchQueue.main.async {
                                self.coinsByLosers += losers
                                completion()
                            }
                        case .error(let error):
                            print("error getting losers: \(error.localizedDescription)")
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchRecentlyAdded(completion: @escaping () -> Void) {
        let url = Constants.backendBaseUrl + "recentlyAddedTokens"

        AF.request(url, method: .get).responseDecodable(of: [TokenDetails].self) { response in
            switch response.result {
            case .success(let recent):
                DispatchQueue.main.async {
                    self.recentlyAddedTokens += recent
                }
                print("got recently added!!: \(recent.count) && \(self.recentlyAddedTokens.count)")

                if let storage = StorageService.shared.recentlyAddedTokens {
                    storage.async.setObject(recent, forKey: "recentlyAddedTokens") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api recently added: \(error)")
                if let storage = StorageService.shared.recentlyAddedTokens {
                    storage.async.object(forKey: "recentlyAddedTokens") { result in
                        switch result {
                        case .value(let recent):
                            print("got recently added!! \(recent)")

                            DispatchQueue.main.async {
                                self.recentlyAddedTokens += recent
                                completion()
                            }
                        case .error(let error):
                            print("error getting losers: \(error.localizedDescription)")
                            completion()
                        }
                    }
                }
            }
        }
    }

    func fetchPublicTreasury(coin: PublicTreasuryCoins, completion: @escaping () -> Void) {
        let url = "https://api.coingecko.com/api/v3/companies/public_treasury/" + coin.rawValue

        if let storage = StorageService.shared.publicTreasury {
            storage.async.object(forKey: "publicTreasury\(coin.rawValue)") { result in
                switch result {
                case .value(let treasury):
                    print("got local Treasury!! \(String(describing: treasury.companies?.count))")

                    DispatchQueue.main.async {
                        self.publicTreasury = treasury
                        completion()
                    }
                case .error(let error):
                    print("error getting local treasury: \(error.localizedDescription)")
                    completion()
                }
            }
        }

        AF.request(url, method: .get).responseDecodable(of: PublicTreasury.self) { response in
            switch response.result {
            case .success(let treasury):
                DispatchQueue.main.async {
                    self.publicTreasury = treasury
                }
                print("got top treasury!!")

                if let storage = StorageService.shared.publicTreasury {
                    storage.async.setObject(treasury, forKey: "publicTreasury\(coin.rawValue)") { _ in }
                }

                completion()
            case .failure(let error):
                print("error getting api top treasury: \(error)")
            }
        }
    }

    func fetchTokenDetails(id: String?, address: String?, completion: @escaping (TokenDescriptor?) -> Void) {
        guard id != nil || address != nil else {
            completion(nil)
            return
        }

        if let storage = StorageService.shared.tokenDescriptor {
            storage.async.object(forKey: "tokenDetails\(id ?? address ?? "")") { result in
                switch result {
                case .value(let token):
                    print("got token details data locally")
                    completion(token)
                case .error(let error):
                    print("error getting token data locally: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }

        var url: String {
            if let id = id {
                return Constants.backendBaseUrl + "getTokenId?id=" + id
            } else if let address = address {
                return Constants.backendBaseUrl + "getTokenByAddress?address=" + address
            } else { return "" }
        }

        print("the url to find the token details is: \(url.debugDescription)")

        AF.request(url, method: .get).responseDecodable(of: TokenDescriptor.self) { response in
            switch response.result {
            case .success(let token):

                if let storage = StorageService.shared.tokenDescriptor {
                    storage.async.setObject(token, forKey: "tokenDetails\(id ?? address ?? "")") { _ in }
                }

                DispatchQueue.main.async {
                    completion(token)
                }
                print("done getting token details data: \(String(describing: token.name))")

            case .failure(let error):
                print("error fetching global market data: \(error)")
                completion(nil)
            }
        }
    }

    func fetchTokenChart(id: String, from: Date, toDate: Date, completion: @escaping ([ChartValue]?) -> Void) {
        let url = Constants.backendBaseUrl + "getTokenByIdChart?tokenId=" + id + "&from=\(Int(from.timeIntervalSince1970))" + "&to=\(Int(toDate.timeIntervalSince1970))"

        print("the url to find the token chart is: \(url.debugDescription)")

        AF.request(url, method: .get).responseDecodable(of: [ChartValue].self) { response in
            switch response.result {
            case .success(let chart):
                if let storage = StorageService.shared.tokenCharts {
                    storage.async.setObject(chart, forKey: "tokenCharts\(id)") { _ in }
                }
                print("done getting token chart data \(chart)")

                DispatchQueue.main.async {
                    completion(chart)
                }

            case .failure(let error):
                print("error fetching chart data: \(error)")
                if let storage = StorageService.shared.tokenCharts {
                    storage.async.object(forKey: "tokenCharts\(id)") { result in
                        switch result {
                        case .value(let token):
                            completion(token)
                        case .error(let error):
                            print("error getting token chart locally: \(error.localizedDescription)")
                            completion(nil)
                        }
                    }
                }
            }
        }
    }

    func fetchTrending(completion: @escaping () -> Void) {
        if let storage = StorageService.shared.trendingStorage {
            storage.async.object(forKey: "trendingList") { result in
                switch result {
                case .value(let list):
                    print("got local trending tokens")
                    DispatchQueue.main.async {
                        self.trendingCoins = list
                    }
                case .error(let error):
                    print("error getting local trending tokens: \(error.localizedDescription)")
                }
            }
        }

//        let url = Constants.backendBaseUrl + "trending"
        let urlDirect = "https://api.coingecko.com/api/v3/search/trending"

        AF.request(urlDirect, method: .get).responseDecodable(of: TrendingCoins.self) { response in
            switch response.result {
            case .success(let trending):
                if let list = trending.coins {
                    print("trending coins success: \(list.count)")
                    self.trendingCoins = list

                    if let storage = StorageService.shared.trendingStorage {
                        storage.async.setObject(list, forKey: "trendingList") { result in
                            switch result {
                            case .value(let val):
                                print("saved trending coins successfully: \(val)")

                            case .error(let error):
                                print("error saving: \(error)")
                            }
                        }
                    }
                }

                completion()

            case .failure(let error):
                print("error loading trending list: \(error)")

                completion()
            }
        }
    }

}
