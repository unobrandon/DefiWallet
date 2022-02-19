//
//  NetworkingService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/14/22.
//

import Foundation

class NetworkingService: ObservableObject {

    enum NetworkStatus: Equatable {
        case connected
        case connecting
        case offline
        case unknown
    }

    static var shared: NetworkingService = NetworkingService()

    init() {
        print("Init network service")
        self.networkStatus = .connecting
    }

    @Published var networkStatus: NetworkStatus {
        didSet {
            switch networkStatus {
            case .offline:
                // Show offline local noti HUD here
                print("offline network status")

            case .connected:
                // Dismiss any loading noti HUD here
                print("connected network status")

            case .connecting:
                // Show loading indicator here
                print("connecting network status")

            case .unknown:
                // Show error noti HUD here
                print("unknown network status")
            }
        }
    }

    func getConfigValue(forKey key: String) -> String? {
        return Bundle.main.infoDictionary?[key] as? String
    }

}
