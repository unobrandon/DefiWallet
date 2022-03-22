//
//  Double+Extenions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/10/22.
//

import Foundation

extension Double {

    func truncate(places: Int) -> Double {
        return Double(floor(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }

}
