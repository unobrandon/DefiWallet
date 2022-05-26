//
//  HapticFeedback.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import UIKit

struct HapticFeedback {

    static func rigidHapticFeedback() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }

    static func lightHapticFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func softHapticFeedback() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    static func mediumHapticFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    static func heavyHapticFeedback() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    static func successHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func warningHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    static func errorHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

}
