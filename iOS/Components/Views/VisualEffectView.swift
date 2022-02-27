//
//  VisualEffectView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {

    var effect: UIVisualEffect?

    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }

    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }

}
