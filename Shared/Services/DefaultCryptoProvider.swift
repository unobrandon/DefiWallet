//
//  DefaultCryptoProvider.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/21/23.
//

import Foundation
import Auth
import CryptoSwift

struct DefaultCryptoProvider: CryptoProvider {
	
	public func recoverPubKey(signature: EthereumSignature, message: Data) throws -> Data {

		return Data()
	}
	
	public func keccak256(_ data: Data) -> Data {
		let digest = SHA3(variant: .keccak256)
		let hash = digest.calculate(for: [UInt8](data))
		return Data(hash)
	}
}
