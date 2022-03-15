//
//  BaseBackgroundColor.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/14/22.
//

import SwiftUI
    
struct BaseBackgroundColor<Content: View>: View {

    private let content: Content
    private let style: AppStyle

    init(style: AppStyle, @ViewBuilder _ content: () -> Content) {
        self.style = style
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color(style == .border ? "baseBackground_bordered" : "baseBackground").ignoresSafeArea()

            content
        }
        
    }
}
