//
//  WelcomeService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation
import SwiftUI
import web3swift

class UserOnboardingServices: ObservableObject {

    @Published var generatedAddress: String = ""
    @Published var secretPhrase: [String] = ["essay", "work", "merry", "clap", "coast", "arm", "nephew", "dog", "banana", "liberty", "please", "reward"]

    let generateWalletDelay = 6.0

    func pasteText() -> String {
        guard let clipboard = UIPasteboard.general.string else {
            return ""
        }

        return clipboard.cleanUpPastedText()
    }

    func copyPrivateKey() {
        UIPasteboard.general.string = secretPhrase.joined(separator: " ")
    }

    func newWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            let myWallet = Wallet(address: "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9", data: Data(), name: "testNameee", isHD: true)

            let newUser = CurrentUser(accessToken: UUID().uuidString,
                                      walletAddress: "testUsernamelol",
                                      secretPhrase: "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9",
                                      password: "http://",
                                      username: "",
                                      avatar: "",
                                      accountValue: "0.00",
                                      wallet: myWallet)

            AuthenticationService.shared.authStatus = .authenticated(newUser)

            completion?()
        }
    }

    func importWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            print("import wallet")
            completion?()
        }
    }

    // MARK: Create/Import Wallet

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
}
