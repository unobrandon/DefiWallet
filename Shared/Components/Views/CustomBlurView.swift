//
//  CustomBlurView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/27/22.
//

import SwiftUI

struct CustomBlurView: UIViewRepresentable {

    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> Void

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }

}
