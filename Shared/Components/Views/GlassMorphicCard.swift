//
//  GlassMorphicCard.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/27/22.
//

import SwiftUI

struct GlassMorphicCard: View {

    @Environment(\.colorScheme) var colorScheme

    var name: String
    var address: String

    @State var blurView: UIVisualEffectView = .init()
    @State var defaultBlurRadius: CGFloat = 0
    @State var defaultSaturationAmount: CGFloat = 0
    @State var activate: Bool = false

    var body: some View {
        ZStack {
            CustomBlurView(effect: .systemUltraThinMaterial) { view in
                blurView = view
                if defaultBlurRadius == 0 { defaultBlurRadius = view.gaussianBlurRadius }
                if defaultSaturationAmount == 0 { defaultSaturationAmount = view.saturationAmount }
            }
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))

            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(
                    .linearGradient(colors: [
                        .white.opacity(colorScheme == .dark ? 0.25 : 0.05),
                        .white.opacity(colorScheme == .dark ? 0.05 : 0.15),
                        .black.opacity(colorScheme == .dark ? 0.0 : 0.15)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .blur(radius: 5)

            // MARK: Borders
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .stroke(
                    .linearGradient(colors: [
                        .white.opacity(0.6),
                        .clear,
                        .purple.opacity(0.2),
                        .purple.opacity(0.5)
                    ], startPoint: .topLeading, endPoint: .bottomTrailing),
                    lineWidth: 1.4)
        }
        .shadow(color: .black.opacity(0.15), radius: colorScheme == .dark ? 2 : 5, x: -4, y: 4)
        .shadow(color: .black.opacity(0.15), radius: colorScheme == .dark ? 2 : 5, x: 4, y: -4)
        .overlay(content: {
            cardContent()
                .opacity(activate ? 1 : 0)
                .animation(.easeIn(duration: 0.5), value: activate)
        })
        .padding(.horizontal, 25)
        .frame(height: 220)
        .onAppear {
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                self.activate = true
            }
        }
    }

    // MARK: Card Content
    @ViewBuilder func cardContent() -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("MEMBERSHIP")
                    .fontTemplate(DefaultTemplate.headingMedium)
                Spacer()

                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            }.offset(y: -5)
            Spacer()

            Text(self.name.uppercased())
                .fontTemplate(DefaultTemplate.subheadingSemiBold)

            Text(self.address)
                .fontTemplate(DefaultTemplate.bodyMono)
        }
        .padding(20)
        .padding(.vertical, 10)
        .blendMode(.overlay)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

}
