//
//  HapticFeedback.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import UIKit

public struct HapticFeedback {

    public static func rigidHapticFeedback() {
        UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }

    public static func lightHapticFeedback() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    public static func softHapticFeedback() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }

    public static func mediumHapticFeedback() {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }

    public static func heavyHapticFeedback() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
    }

    public static func successHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    public static func warningHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)
    }

    public static func errorHapticFeedback() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }

}
