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
import WalletConnectPairing
import WalletConnectNetworking
import Web3Wallet
import Web3Inbox
import FirebaseAuth

class Web3InboxSigner {
	static func onSign(_ message: String) -> SigningResult {
//		let privateKey = "sfa"
//		let signer = MessageSignerFactory(signerFactory: DefaultSignerFactory()).create()
//		let signature = try! signer.sign(message: message, privateKey: privateKey, type: .eip191)
		return .rejected
	}
}

class UnauthenticatedServices: ObservableObject {

    @Published var unauthenticatedWallet: Wallet = Wallet(address: "", data: Data(), name: "", isHD: true)
    @Published var password: String = ""
    @Published var prefCurrency: String = "usd"
    @Published var secretPhrase: [String] = []
    @Published var hasEnsName: Bool = false

    var registeredUser: RegisteredUser?

    init() {
		let metadata = AppMetadata(name: Constants.projectName,
								   description: "Difi Wallet App",
								   url: "defi.wallet",
								   icons: [Constants.walletConnectMetadataIcon],
								   verifyUrl: "verify.walletconnect.com")
		
		Networking.configure(projectId: Constants.walletConnectProjectId, socketFactory: DefaultSocketFactory())
		Pair.configure(metadata: metadata)

//		let ethBlockchain = Blockchain("eip155:1")!
		let polygonBlockchain = Blockchain("eip155:137")!
		let account = Account(blockchain: polygonBlockchain, address: "0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9")!

		Web3Inbox.configure(account: account, onSign: Web3InboxSigner.onSign, environment: .production)
		
		Web3Wallet.configure(
			metadata: metadata,
			crypto: DefaultCryptoProvider(),
			// Used for the Echo: "echo.walletconnect.com" will be used by default if not provided
			echoHost: "echo.walletconnect.com",
			// Used for the Echo: "APNSEnvironment.production" will be used by default if not provided
			environment: .production)
		
		do {
			// Echo SDK allows users to receive push notifications on their devices
			// about important events, such as an auth request or a sign session request.
			let clientId = try Networking.interactor.getClientId()
			print("the wc client id is: \(clientId)")
			Echo.configure(clientId: clientId, environment: .production)
		} catch {
			print("could not get wallet connect netowrk client ID")
		}
	}

    func generateWallet(completion: (() -> Void)?) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let newWallet = self.createAccountWithSeedPhrase(walletName: "", password: "", seedStrength: .twelveWords) {
                DispatchQueue.main.async {
					print("done generating wallet: \(newWallet.data.debugDescription) && \(self.secretPhrase.description)")
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

    func createNewUser(username: String?, password: String?, address: String, currency: String?, deviceToken: String?, completion: ((Bool) -> Void)?) {
        let backendUrl = "api/v1/auth/createNewUser" // ?username=\(username)&password=\(password)&address=\(address)&currency=\(currency)&deviceToken=\(deviceToken)"
        let requestUrl = "http://localhost:3001/" + backendUrl // Constants.backendBaseUrl + backendUrl
		
		let parameters: [String: Any] = [
			"address": self.unauthenticatedWallet.address.lowercased()
		]
        
		print("the address sending is: \(self.unauthenticatedWallet.address.lowercased())")
        AF.request(requestUrl, method: .post, parameters: parameters).responseDecodable(of: CreateNewUser.self) { response in
            switch response.result {
            case .success(let newUser):
                print("success registering: \(newUser)")
                // self.registeredUser = newUser
				
				Auth.auth().signIn(withCustomToken: newUser.token) { (authResult, error) in
					if let error = error {
						print("Error signing in with custom token:", error)
						return
					}
					
					// User is signed in!
					if let user = authResult?.user {
						print("Signed in as:", user.uid)
					}
				}

				
                completion?(true)
            case .failure(let error):
                print("error loading register: \(error)")
                completion?(false)
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
	
	func authRequestPayload(completion: ((AuthWalletRequest?) -> Void)?) {
		let authRequestUrl = "http://localhost:3001/auth/payload"
		let parameters: [String: Any] = [
			"address": self.unauthenticatedWallet.address.lowercased()
		]
		
		AF.request(authRequestUrl, method: .post, parameters: parameters).responseDecodable(of: AuthWalletRequest.self) { response in
			switch response.result {
			case .success(let authMessage):
				print("success getting auth message: \(authMessage)")
				completion?(authMessage)
			case .failure(let error):
				print("error loading auth message: \(error)")
				completion?(nil)
			}
		}
	}
	
	func authRequestMessage(completion: ((AuthRequestMsg?) -> Void)?) {
		let authRequestUrl = "https://defiwallet-backend-dev-ts.herokuapp.com/api/v1/auth/authRequestMessage"
		let parameters: [String: Any] = [
			"address": self.unauthenticatedWallet.address
		]

		AF.request(authRequestUrl, method: .post, parameters: parameters).responseDecodable(of: AuthRequestMsg.self) { response in
			switch response.result {
			case .success(let authMessage):
				print("success getting auth message: \(authMessage)")
				completion?(authMessage)
			case .failure(let error):
				print("error loading auth message: \(error)")
				completion?(nil)
			}
		}
	}
	
	func authVerifyMessage(_ requestMsg: AuthWalletRequest, completion: @escaping (Bool) -> Void) {
		do {
			let keystore = getUnAuthKeyStoreManager()
			print("all my wallets are: \(keystore.addresses?.last) && \(keystore.addresses?.first)")
			guard let account = keystore.addresses?.first else {
				print("Failed to get account or statement.")
				completion(false)
				return
			}
			
			let encoder = JSONEncoder()
			let message = try encoder.encode(requestMsg)
			
			guard let signatureData = try Web3Signer.signPersonalMessage(message, keystore: keystore, account: account, password: "") else {
				print("Failed to sign message.")
				completion(false)
				return
			}
			
			let signatureHexString = signatureData.toHexString()
			
			let authVerifyUrl = "http://localhost:3001/api/v1/auth/login"
			
			do {
				let jsonData = try JSONEncoder().encode(requestMsg.payload)
				if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [String: Any] {
					
					var payload: [String: Any] = [:]
					payload["signature"] = signatureHexString
					payload["type"] = jsonDict["type"] as? String ?? ""
					payload["domain"] = jsonDict["domain"] as? String ?? ""
					payload["address"] = jsonDict["address"] as? String ?? ""
					payload["statement"] = jsonDict["statement"] as? String ?? ""
					payload["version"] = jsonDict["version"] as? String ?? ""
					payload["chain_id"] = jsonDict["chain_id"] as? String ?? ""
					payload["nonce"] = jsonDict["nonce"] as? String ?? ""
					payload["issued_at"] = jsonDict["issued_at"] as? String ?? ""
					payload["expiration_time"] = jsonDict["expiration_time"] as? String ?? ""
					payload["invalid_before"] = jsonDict["invalid_before"] as? String ?? ""
//
//					if let resources = jsonDict["resources"] as? [String] {
//						payload["resources"] = resources
//					}

//
//					if let resources = jsonDict["resources"] as? [String] {
//						payload["resources"] = resources
//					}
					
					print(payload)
					
					AF.request(authVerifyUrl, method: .post, parameters: ["payload": payload], encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"]).responseData { response in
						switch response.result {
						case .success(let data):
							// Convert data to string and print it
							if let jsonString = String(data: data, encoding: .utf8) {
								print("Received JSON: \(jsonString)")
							}
							
							do {
								let verifyMessage = try JSONDecoder().decode(AuthVerifyMsg.self, from: data)
								print("Decoded message: \(verifyMessage)")
								completion(true)
							} catch {
								print("Failed to decode message: \(error)")
								completion(false)
							}
							
						case .failure(let error):
							print("Error verifying auth message: \(error)")
							completion(false)
						}
					}
				}
			} catch {
				print("Failed to serialize AuthWalletRequestPayload object: \(error)")
			}
		} catch {
			print("Error occurred: \(error)")
			completion(false)
		}
	}


	
	
	/*
	func authVerifyMessage(_ requestMsg: AuthWalletRequest, completion: ((Bool) -> Void)?) {
//		let web3 = Web3.InfuraMainnetWeb3(accessToken: "9c67adedf10e471ea58f82c424d011f3")
//		let ethAccount = EthereumAddress(self.unauthenticatedWallet.data)!
		// let signMsg = try web3.wallet.signPersonalMessage(message1, account: ethAccount)

		do {
			let keystore = getUnAuthKeyStoreManager()
			if let account = keystore.addresses?.first, let statement = requestMsg.payload?.statement?.data(using: .utf8) {
				let me = try Web3Signer.signPersonalMessage(statement, keystore: keystore, account: account, password: "")
				print("the signature is: \(me?.toHexString() ?? "") \n or or \(me?.debugDescription ?? "") \n and statement: \(statement)")
				
				let authVerifyUrl = "http://localhost:3001/auth/login"
				//		let signedMsg = self.signMessage(requestMsg.message, self.unauthenticatedWallet.data) ?? ""
				let parameters: [String: Any] = [
					"signature": me?.toHexString() ?? "",
					"statement": requestMsg.payload?.statement ?? "" //.replacingOccurrences(of: "\n", with: "")
				]
				
				AF.request(authVerifyUrl, method: .post, parameters: parameters).responseDecodable(of: AuthVerifyMsg.self) { response in
					switch response.result {
					case .success(let verifyMessage):
						print("success verifying auth message: \(verifyMessage)")
						completion?(true)
					case .failure(let error):
						print("error verifying auth message: \(error)")
						completion?(false)
					}
				}
			} else {
				print("not right nosldrknsdklfjvn")
			}
		} catch {
			print("error signing message!")
			completion?(false)
		}
		

	}
*/
	 
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
	
	//  MARK: Sign Wallet
	
	func signMessage(_ message: String?, _ addressData: Data) -> String? {
		
//		let message1 = "defi.wallet wants you to sign in with your Ethereum account:\n0x41914acD93d82b59BD7935F44f9b44Ff8381FCB9\n\nPlease confirm\n\nURI: https://defi.wallet/\nVersion: 1\nChain ID: 1\nNonce: IAVXRqUqk5nRuHd2w\nIssued At: 2023-05-16T16:29:29.233Z\nExpiration Time: 2023-05-16T16:39:28.347Z\nNot Before: 2023-05-16T16:29:28.347Z\nResources:"
		let web3 = Web3.InfuraMainnetWeb3(accessToken: "9c67adedf10e471ea58f82c424d011f3")
//		let web3 = web3swift.web3(provider: InfuraProvider(Networks.Mainnet)!)

//		if let ethAccount = EthereumAddress(fromHex: addressData.toHexString()), let message = message {
			do {
//				let me = try web3.wallet.getAccounts()
//				print("meee is: \(me.debugDescription)")
				let account = try web3.wallet.getAccounts().first
				let signMsg = try web3.wallet.signPersonalMessage(message ?? "", account: account!)
				
				print("THE SIGNED MESSAGE WE WILL SEND BACK!!!! \(signMsg.toHexString())")
				return signMsg.toHexString()
			} catch {
				print("Failed to get data from message.")
				return nil
			}
//		} else {
//			print("eth account does not work!!")
//			return nil
//		}
		

		
//		let endpoint = "https://speedy-nodes-nyc.moralis.io/" + "b8a2c97baf6d1f1c575ebd0e/eth/mainnet"
//		guard let url = URL(string: endpoint), let web3Http = Web3HttpProvider(url) else {
//			return
//		}
//
//		let web = web3(provider: web3Http)
//		let web3Rinkeby = Web3.InfuraRinkebyWeb3()
//		if let ethAccount = EthereumAddress(fromHex: ) {
//			do {
//				let signMsg = try web3Rinkeby.wallet.signPersonalMessage(message, account: ethAccount)
//
//				print("THE SIGNED MESSAGE WE WILL SEND BACK!!!! \(signMsg.description)")
//			} catch {
//				print("Failed to get data from message.")
//			}
//		} else {
//			print("eth account does not work!!")
//		}
		
//
//		///
//		let keystore = try! EthereumKeystoreV3(password: "")
//		let keystoreManager = KeystoreManager([keystore!])
//		web3Rinkeby.addKeystoreManager(keystoreManager)
//		let address = keystoreManager.addresses![0]
//		///
//
//		let data = message.data(using: .utf8)
//		do {
//			let signMsg = try web3Rinkeby.wallet.signPersonalMessage(data!, account: address)
//
//			print("THE SIGNED MESSAGE WE WILL SEND BACK!!!! \(signMsg.description)")
//		} catch {
//			print("Failed to get data from message.")
//		}
	}

	private func getUnAuthKeyStoreManager() -> KeystoreManager {
		let data = self.unauthenticatedWallet.data
		let keystoreManager: KeystoreManager
		if self.unauthenticatedWallet.isHD {
			let keystore = BIP32Keystore(data)!
			keystoreManager = KeystoreManager([keystore])
		} else {
			let keystore = EthereumKeystoreV3(data)!
			keystoreManager = KeystoreManager([keystore])
		}
		
		return keystoreManager
	}
	
    func checkNotificationPermission(completion: @escaping ((Bool) -> Void)) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            if settings.authorizationStatus == .notDetermined {
                completion(false)
            } else if settings.authorizationStatus == .denied {
                completion(false)
            } else if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
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
