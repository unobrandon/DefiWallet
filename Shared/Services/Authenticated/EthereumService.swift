//
//  EthereumService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/19/22.
//

import SwiftUI
import web3swift

class EthereumService: ObservableObject {

    // MARK: web3
    var web3Service: web3?
    var socketProvider: WebsocketProvider?

    var keystore: EthereumKeystoreV3?
    var hdKeystore: BIP32Keystore?

    init(currentUser: CurrentUser) {
        print("eth service init")

        let socketUrl = "wss://speedy-nodes-nyc.moralis.io/b8a2c97baf6d1f1c575ebd0e/eth/mainnet/ws"
        socketProvider = WebsocketProvider(socketUrl, delegate: self, network: .Mainnet)

        socketProvider?.connectSocket()

        if let provider = socketProvider {
            web3Service = web3(provider: provider)
        }
    }

    deinit {
        print("deinit authenticated services")

        socketProvider?.disconnectSocket()
    }

    // MARK: Create Wallet

    // Create wallet with Private Key - wallet is NOT HD
    private func createAccountWithPrivateKey(walletName: String, password: String) -> Wallet {
        let keystore = try! EthereumKeystoreV3(password: password)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: walletName, isHD: false)

        return wallet
    }

    // Create wallet with Seed Phrase - wallet is HD
    private func createAccountWithSeedPhrase(walletName: String, password: String, seedStrength: SeedStrength) -> Wallet {
        let bitsOfEntropy: Int = seedStrength == .twelveWords ? 128 : 256 // Entropy is a measure of password strength. Usually used 128 or 256 bits.

        let mnemonics = try! BIP39.generateMnemonics(bitsOfEntropy: bitsOfEntropy)!
        let keystore = try! BIP32Keystore(mnemonics: mnemonics, password: password, mnemonicsPassword: "", language: .english)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: walletName, isHD: true)

        return wallet
    }


    // MARK: Import Wallet
    
    // Example: "fine have legal roof fury bread egg knee wrong idea must edit"
    private func importWithSeed(seedPhrase: String, walletName: String, password: String) -> Wallet {
        let keystore = try! BIP32Keystore(mnemonics: seedPhrase, password: password, mnemonicsPassword: "", language: .english)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: walletName, isHD: true)
        
        return wallet
    }

    // Example: "L2HRewdY7SSpB2jjKq6mwLes86umkWBuUSPZWE35Q8Pbbr8wVyss124sf124dfsf"
    private func importWithPrivateKey(privateKey: String, walletName: String, password: String) -> Wallet {
        let formattedKey = privateKey.trimmingCharacters(in: .whitespacesAndNewlines)
        let dataKey = Data.fromHex(formattedKey)!

        let keystore = try! EthereumKeystoreV3(privateKey: dataKey, password: password)!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams)

        let address = keystore.addresses!.first!.address
        let wallet = Wallet(address: address, data: keyData, name: walletName, isHD: false)
        
        return wallet
    }

}
