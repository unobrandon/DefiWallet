//
//  AccountBalance.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//

import Foundation
import Alamofire

// MARK: - AccountBalance
struct AccountBalance: Codable {

    let error: [String]?
    let completeBalance: [CompleteBalance]?

}
