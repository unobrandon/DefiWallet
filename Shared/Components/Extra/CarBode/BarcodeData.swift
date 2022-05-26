//
//  BarcodeData.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/19/22.
//

import AVFoundation
import UIKit

public struct BarcodeData {

    public let value: String
    public let type: AVMetadataObject.ObjectType

    public init(value: String, type: AVMetadataObject.ObjectType) {
        self.value = value
        self.type = type
    }

}
