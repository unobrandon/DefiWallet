//
//  NotificationHUD.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct NotificationHUD: View {

    @State var showHUD: Bool = false
    let delayDuration = 3.5

    private let image: String
    private let color: Color
    private let title: String
    private let subtitle: String

    init(image: String, color: Color, title: String) {
        self.image = image
        self.color = color
        self.title = title
        self.subtitle = ""
    }

    init(image: String, color: Color, title: String, subtitle: String) {
        self.image = image
        self.color = color
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        ZStack {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                withAnimation(.easeInOut(duration: 0.45)) {
                    showHUD = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                    getRootController().view.subviews.forEach { view in
                        if view.tag == 1009 {
                            view.removeFromSuperview()
                        }
                    }
                }
            }, label: {
                HStack(spacing: 10) {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 26, height: 26, alignment: .center)
                        .foregroundColor(color)
                        .font(Font.title.weight(.regular))

                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(.none)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                        if subtitle != "" {
                            Text(subtitle)
                                .font(.caption)
                                .fontWeight(.regular)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                                .lineLimit(3)
                        }
                    }
                }.padding(10)
                .padding(.horizontal, 10)
                .padding(.trailing, subtitle == "" ? 0 : 10)
                .background(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .foregroundColor(.clear)
                        .overlay(Capsule().stroke(Color("baseBackground").opacity(0.4), lineWidth: 2.5))
                )
            })
            .buttonStyle(ClickInteractiveStyle(0.99))
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .offset(y: showHUD ? 0 : -200)
            .onAppear {
                withAnimation(.spring(response: 0.45, dampingFraction: 0.7, blendDuration: 0)) {
                    showHUD = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + delayDuration) {
                    withAnimation(.easeInOut(duration: 0.45)) {
                        showHUD = false
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                        guard !showHUD else { return }

                        getRootController().view.subviews.forEach { view in
                            if view.tag == 1009 {
                                view.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
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

}
