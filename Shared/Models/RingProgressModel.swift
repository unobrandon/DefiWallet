//
//  RingProgressModel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct RingProgressModel: Identifiable {

    var id = UUID().uuidString
    var progress: Double
    var value: String
    var keyIcon: String
    var keyColor: Color
    var isText: Bool = false

}
