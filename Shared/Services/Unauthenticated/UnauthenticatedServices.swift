//
//  UnauthenticatedServices.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import NotificationCenter
import Alamofire
import web3swift

class UnauthenticatedServices: ObservableObject {

    @Published var unauthenticatedWallet: Wallet = Wallet(address: "", data: Data(), name: "", isHD: true)
    @Published var password: String = ""
    @Published var prefCurrency: String = "usd"
    @Published var secretPhrase: [String] = []
    @Published var hasEnsName: Bool = false

    var registeredUser: RegisteredUser?

    init() { }

    func generateWallet(completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let newWallet = self.createAccountWithSeedPhrase(walletName: "", password: "", seedStrength: .twelveWords) {
                DispatchQueue.main.async {
                    print("done generating wallet: \(newWallet.address) && \(self.secretPhrase.description)")
                    self.unauthenticatedWallet = newWallet
                    self.unauthenticatedWallet.name = newWallet.address.formatAddress()

                    completion?()
                }
            }
        }
    }

    func importWallet(_ phrase: String, name: String, password: String, completion: (() -> Void)?) {
        if isWalletHD(phrase) {
            DispatchQueue.main.async {
                if let seedWallet = self.importWithSeed(seedPhrase: phrase, walletName: name, password: password) {
                    self.unauthenticatedWallet = seedWallet
                }

                completion?()
            }
        } else {
            DispatchQueue.main.async {
                if let wallet = self.importWithPrivateKey(privateKey: phrase, walletName: name, password: password) {
                    self.unauthenticatedWallet = wallet
                }

                completion?()
            }
        }
    }

    func checkPhraseValid(_ phrase: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.global(qos: .userInteractive).async {
            if self.isWalletHD(phrase) {
                do {
                    let keystore = try BIP32Keystore(mnemonics: phrase, password: "password", mnemonicsPassword: "", language: .english)
                    let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

                    DispatchQueue.main.async {
                        guard let address = keystore?.addresses?.first?.address else {
                            completion?(false)
                            return
                        }

                        self.unauthenticatedWallet = Wallet(address: address, data: keyData, name: address.formatAddress(), isHD: true)

                        completion?(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                }
            } else {
                let formattedKey = phrase.trimmingCharacters(in: .whitespacesAndNewlines)

                guard let dataKey = Data.fromHex(formattedKey) else {
                    DispatchQueue.main.async { completion?(false) }
                    return
                }

                do {
                    let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: "password")
                    let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

                    DispatchQueue.main.async {
                        guard let address = keystore?.addresses?.first?.address else {
                            completion?(false)
                            return
                        }

                        self.unauthenticatedWallet = Wallet(address: address, data: keyData, name: address.formatAddress(), isHD: false)

                        completion?(true)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                }
            }
        }
    }

    func getStarted() {
        guard let user = registeredUser else { return }

        let newUser = CurrentUser(objectId: user.objectId,
                                  sessionToken: user.sessionToken,
                                  address: unauthenticatedWallet.address,
                                  mediumAddress: unauthenticatedWallet.address.formatAddressExtended(),
                                  shortAddress: unauthenticatedWallet.address.formatAddress(),
                                  secretPhrase: secretPhrase,
                                  password: password,
                                  username: user.username,
                                  avatar: nil,
                                  miniAvatar: nil,
                                  currency: user.currency,
                                  createdAt: user.createdAt,
                                  updatedAt: user.updatedAt,
                                  wallet: unauthenticatedWallet)

        AuthenticationService.shared.authStatus = .authenticated(newUser)
    }

    private func isWalletHD(_ text: String) -> Bool {
        guard let count = text.countWords(),
                count == 12 || count == 24 else {
            return false
        }

        return true
    }

    func registerUser(username: String, password: String, address: String, currency: String, completion: ((Bool) -> Void)?) {
        DispatchQueue.global(qos: .userInteractive).async {
            let backendUrl: String = "createNewUser?username=\(username)&password=\(password)&address=\(address)&currency=\(currency)"

            AF.request(Constants.backendBaseUrl + backendUrl, method: .get).responseDecodable(of: RegisteredUser.self) { response in
                switch response.result {
                case .success(let newUser):
                    print("success reregistering: \(newUser)")
                    self.registeredUser = newUser

                    completion?(true)
                case .failure(let error):
                    print("error loading register: \(error)")
                    completion?(false)
                }
            }
        }
    }

    func checkEnsUsername(address: String, completion: ((Bool) -> Void)?) {
        let endpoint = "https://speedy-nodes-nyc.moralis.io/" + "b8a2c97baf6d1f1c575ebd0e/eth/mainnet"
        guard let url = URL(string: endpoint), let web3Http = Web3HttpProvider(url) else {
            completion?(false)
            return
        }

        let web = web3(provider: web3Http)
        if let ens = ENS(web3: web) {
            do {
                let name = try ens.getAddress(forNode: address)
                print("found wallet with ENS name: \(name)")

                completion?(true)
            } catch {
                completion?(false)
            }
        }
    }

    // MARK: Create Wallet

    // Create wallet with Seed Phrase - wallet is HD
    // Example: "fine have legal roof fury bread egg knee wrong idea must edit"
    private func createAccountWithSeedPhrase(walletName: String, password: String, seedStrength: SeedStrength) -> Wallet? {

        // Entropy is a measure of password strength. Usually used 128 or 256 bits.
        let bitsOfEntropy: Int = seedStrength == .twelveWords ? 128 : 256

        do {
            guard let mnemonics = try BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy) else { return nil }

            let keystore = try BIP32Keystore(mnemonics: mnemonics, password: password, mnemonicsPassword: "", language: .english)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else { return nil }

            DispatchQueue.main.async {
                self.secretPhrase = mnemonics.components(separatedBy: " ")
            }

            return Wallet(address: address, data: keyData, name: walletName, isHD: true)
        } catch {
            return nil
        }
    }

    // Create wallet with Private Key - wallet is NOT HD
    // Example: "L2HRewdY7SSpB2jjKq6mwLes86umkWBuUSPZWE35Q8Pbbr8wVyss124sf124dfsf"
    private func createAccountWithPrivateKey(walletName: String, password: String) -> Wallet? {
        do {
            let keystore = try EthereumKeystoreV3(password: password)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else { return nil }

            return Wallet(address: address, data: keyData, name: walletName, isHD: false)
        } catch {
            return nil
        }
    }

    // MARK: Import Wallet

    // Example: "fine have legal roof fury bread egg knee wrong idea must edit"
    private func importWithSeed(seedPhrase: String, walletName: String, password: String) -> Wallet? {
        do {
            let keystore = try BIP32Keystore(mnemonics: seedPhrase, password: password, mnemonicsPassword: "", language: .english)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else { return nil }

            return Wallet(address: address, data: keyData, name: walletName, isHD: true)
        } catch {
            return nil
        }
    }

    // Example: "L2HRewdY7SSpB2jjKq6mwLes86umkWBuUSPZWE35Q8Pbbr8wVyss124sf124dfsf"
    private func importWithPrivateKey(privateKey: String, walletName: String, password: String) -> Wallet? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let dataKey = Data.fromHex(formattedKey) else { return nil }

        do {
            let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else { return nil }

            return Wallet(address: address, data: keyData, name: walletName, isHD: false)
        } catch {
            return nil
        }
    }

    func checkNotificationPermission(completion: ((Bool) -> Void)?) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                completion?(false)
            } else if settings.authorizationStatus == .denied {
                completion?(false)
            } else if settings.authorizationStatus == .authorized {
                completion?(true)
            } else {
                completion?(false)
            }
        })
    }

    func pasteText() -> String {
        #if os(iOS)
            guard let clipboard = UIPasteboard.general.string else {
                return ""
            }

            return clipboard.cleanUpPastedText()

        #else
            return ""
        #endif
    }

    func copyPrivateKey() {
        #if os(iOS)
            UIPasteboard.general.string = secretPhrase.joined(separator: " ")
        #endif
    }

}
