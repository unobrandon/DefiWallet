//
//  UIVisualEffectView+Extensions.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/27/22.
//

import SwiftUI

extension UIVisualEffectView {

    var backDrop: UIView? {
        // PRIVATE CLASS
        return subView(forClass: NSClassFromString("_UIVisualEffectBackdropView"))
    }

    var gaussianBlur: NSObject? {
        return backDrop?.value(key: "filters", filter: "gaussianBlur")
    }

    var saturation: NSObject? {
        return backDrop?.value(key: "filters", filter: "colorSaturate")
    }

    var gaussianBlurRadius: CGFloat {
        get {
            return gaussianBlur?.values?["inputRadius"] as? CGFloat ?? 0
        } set {
            gaussianBlur?.values?["inputRadius"] = newValue
            applyNewEffects()
        }
    }

    func applyNewEffects() {
        UIVisualEffectView.animate(withDuration: 0.5) {
            self.backDrop?.perform(Selector(("applyRequestedFilterEffects")))
        }
    }

    var saturationAmount: CGFloat {
        get {
            return saturation?.values?["inputAmount"] as? CGFloat ?? 0
        } set {
            saturation?.values?["inputAmount"] = newValue
            applyNewEffects()
        }
    }

}
