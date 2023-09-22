//
//  DefaultSocketFactory.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/21/23.
//

import Foundation
import Starscream
import WalletConnectRelay
//import SocketIO

extension WebSocket: WalletConnectRelay.WebSocketConnecting {
	public var isConnected: Bool {
		return true
	}
	
	public var onConnect: (() -> Void)? {
		get {
			return nil
		}
		set(newValue) {
			print("wallet connect onConnect new value: \(newValue.debugDescription)")
		}
	}
	
	public var onDisconnect: ((Error?) -> Void)? {
		get {
			return nil
		}
		set(newValue) {
			print("wallet connect onDisconnect new value: \(newValue.debugDescription)")
		}
	}
	
	public var onText: ((String) -> Void)? {
		get {
			return nil
		}
		set(newValue) {
			print("wallet connect onText new value: \(newValue.debugDescription)")
		}
	}
}

struct DefaultSocketFactory: WebSocketFactory {
	func create(with url: URL) -> WebSocketConnecting {
		var urlRequest = URLRequest(url: url)
		urlRequest.addValue("relay.walletconnect.com", forHTTPHeaderField: "Origin")
		return WebSocket(request: urlRequest)
	}
}
