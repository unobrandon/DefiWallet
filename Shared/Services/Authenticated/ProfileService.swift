//
//  ProfileService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/7/22.
//

import Foundation
import Alamofire

class ProfileService: ObservableObject {
    
    func logout(_ sessionToken: String) {
        let url = Constants.backendBaseUrl + "logOut" + "?sessionToken=\(sessionToken)"

        AF.request(url, method: .get).response(completionHandler: { response in
            switch response.result {
            case .success(let result):
                print("successfully logged out: \(String(describing: result?.debugDescription))")

                AuthenticationService.shared.authStatus = .unauthenticated

                #if os(iOS)
                    HapticFeedback.rigidHapticFeedback()
                #endif
            case .failure(let error):
                print("error logging out: \(error)")
                #if os(iOS)
                    HapticFeedback.errorHapticFeedback()
                #endif
            }
        })
    }

}
