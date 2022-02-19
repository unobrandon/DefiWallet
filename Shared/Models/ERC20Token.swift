//
//  ERC20Token.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/19/22.
//


class ERC20Token {

    var name: String
    var address: String
    var decimals: String
    var symbol: String

    init(name: String, address: String, decimals: String, symbol: String) {
        self.name = name
        self.address = address
        self.decimals = decimals
        self.symbol = symbol
    }

}
