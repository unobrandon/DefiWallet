//
//  StoreReviewHelper.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 7/27/22.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int else {
            UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: "APP_OPENED_COUNT")
    }

    static func checkAndAskForReview() {
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: "APP_OPENED_COUNT") as? Int else {
            UserDefaults.standard.set(1, forKey: "APP_OPENED_COUNT")
            return
        }

        switch appOpenCount {
        case 5, 50:
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                StoreReviewHelper.requestReview()
            }
        case _ where appOpenCount % 100 == 0 :
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                StoreReviewHelper.requestReview()
            }
        default:
            // print("App run count is: \(appOpenCount)")
            break;
        }
    }

    static func requestReview() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1531056110") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
