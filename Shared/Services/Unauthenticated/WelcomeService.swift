//
//  WelcomeService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import Foundation
import web3swift

class WelcomeServices: ObservableObject {

    func newWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            AuthenticationService.shared.authStatus = .authenticated(
                CurrentUser(accessToken: UUID().uuidString,
                            username: "testUsernamelol",
                            walletAddress: "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9",
                            accountValue: "0.00",
                            secretPhrase: "")
            )

            completion?()
        }
    }

    func importWallet(completion: (() -> Void)?) {
        DispatchQueue.main.async {
            print("import wallet")
            completion?()
        }
    }

    /*
    // MARK: Create Wallet

    // Create wallet with Private Key - wallet is NOT HD
    private func createAccountWithPrivateKey(walletName: String, password: String) -> Wallet? {
        do {
            let keystore = try EthereumKeystoreV3(password: password)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else {
                return nil
            }

            return Wallet(address: address, data: keyData, name: walletName, isHD: false)

        } catch {
            return nil
        }
    }

    // Create wallet with Seed Phrase - wallet is HD
    private func createAccountWithSeedPhrase(walletName: String, password: String, seedStrength: SeedPhraseStrength) -> Wallet? {
        let bitsOfEntropy: Int = seedStrength == .twelveWords ? 128 : 256
        // Entropy is a measure of password strength. Usually used 128 or 256 bits.

        do {
            guard let mnemonics = try BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy) else { return nil }

            let keystore = try BIP32Keystore(mnemonics: mnemonics, password: password, mnemonicsPassword: "", language: .english)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else {
                return nil
            }

            return Wallet(address: address, data: keyData, name: walletName, isHD: true)

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

            guard let address = keystore?.addresses?.first?.address else {
                return nil
            }

            return Wallet(address: address, data: keyData, name: walletName, isHD: true)

        } catch {
            return nil
        }
    }

    // Example: "L2HRewdY7SSpB2jjKq6mwLes86umkWBuUSPZWE35Q8Pbbr8wVyss124sf124dfsf"
    private func importWithPrivateKey(privateKey: String, walletName: String, password: String) -> Wallet? {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!

        do {
            let keystore = try EthereumKeystoreV3(privateKey: dataKey, password: password)
            let keyData = try JSONEncoder().encode(keystore?.keystoreParams)

            guard let address = keystore?.addresses?.first?.address else {
                return nil
            }

            return Wallet(address: address, data: keyData, name: walletName, isHD: false)

        } catch {
            return nil
        }
    }
     */
     
}
