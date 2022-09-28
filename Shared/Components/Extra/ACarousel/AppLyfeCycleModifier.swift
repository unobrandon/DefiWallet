//
//  AppLyfeCycleModifier.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/1/22.
//

import SwiftUI

#if os(macOS)
import AppKit
typealias Application = NSApplication
#else
import UIKit
typealias Application = UIApplication
#endif

/// Monitor and receive application life cycles,
/// inactive or active
@available(iOS 13.0, OSX 10.15, *)
struct AppLifeCycleModifier: ViewModifier {

    let active = NotificationCenter.default.publisher(for: Application.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: Application.willResignActiveNotification)

    private let action: (Bool) -> Void

    init(_ action: @escaping (Bool) -> Void) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onAppear() /// `onReceive` will not work in the Modifier Without `onAppear`
            .onReceive(active, perform: { _ in
                action(true)
            })
            .onReceive(inactive, perform: { _ in
                action(false)
            })
    }

}

@available(iOS 13.0, OSX 10.15, *)
extension View {

    func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> Void) -> some View {
        self.modifier(AppLifeCycleModifier(action))
    }

}
