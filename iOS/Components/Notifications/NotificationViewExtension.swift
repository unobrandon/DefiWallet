//
//  NotificationViewExtension.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

extension View {

    func showNotiHUD(image: String, color: Color = .primary, title: String, subtitle: String?) {
        // avoiding multiple HUDs...
        if getRootController().view.subviews.contains(where: { view in
            return view.tag == 1009
        }) {
            return
        }

        let hudViewController = UIHostingController(rootView: NotificationHUD(image: image, color: color, title: title, subtitle: subtitle ?? ""))
        let size = hudViewController.view.intrinsicContentSize

        hudViewController.view.frame.size = size
        hudViewController.view.frame.origin = CGPoint(x: (MobileConstants.screenWidth / 2) - (size.width / 2), y: 40)
        hudViewController.view.backgroundColor = .clear
        hudViewController.view.tag = 1009

        getRootController().view.addSubview(hudViewController.view)
    }

    func getRootController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }

        guard let root = screen.windows.last?.rootViewController else {
            return .init()
        }

        return root
    }

    func bringNotiViewToFront() {
        guard let notiView = getRootController().view.subviews.first(where: { $0.tag == 1009 }) else { return }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            UIApplication.shared.windows.first?.bringSubviewToFront(notiView)
        }
    }
}
