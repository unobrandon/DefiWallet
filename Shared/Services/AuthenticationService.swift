//
//  AuthenticationService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation

class AuthenticationService: ObservableObject {

    enum CurrentUserStatus: Equatable {
        case authenticated(CurrentUser)
        case unauthenticated
    }

    static var shared: AuthenticationService = AuthenticationService()

    @Published var authStatus: CurrentUserStatus {
        didSet {
            switch authStatus {
            case .unauthenticated:
                UserDefaults.standard.removeObject(forKey: "currentUser")
            case .authenticated(let user):
                let encoder = JSONEncoder()

                do {
                    let jsonString = try encoder.encode(user)

                    UserDefaults.standard.setValue(jsonString, forKey: "currentUser")
                } catch {
                    authStatus = .unauthenticated
                }
            }
        }
    }

    init() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "currentUser") {
            do {
                self.authStatus = try CurrentUserStatus.authenticated(decoder.decode(CurrentUser.self, from: data))

            } catch {
                self.authStatus = CurrentUserStatus.unauthenticated
            }
        } else {
            self.authStatus = CurrentUserStatus.unauthenticated
        }
    }

}
