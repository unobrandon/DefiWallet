//
//  EnableBiometryBanner.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/5/22.
//

import SwiftUI
import LocalAuthentication

struct BiometryBanner: View {

    @State private var lockedOutText: String = ""
    @State private var toggleOn = false
    private let style: AppStyle
    private let onSuccess: () -> Void

    init(style: AppStyle, onSuccess: @escaping () -> Void) {
        self.style = style
        self.onSuccess = onSuccess
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: lockedOutText == "Touch ID" ? "touchid" : "faceid")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .font(Font.title.weight(.medium))
                .foregroundColor(Color.primary)
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 5) {
                Text(lockedOutText)
                    .fontTemplate(DefaultTemplate.bodyBold)

                Text("Authentication with \(lockedOutText)")
                    .fontTemplate(DefaultTemplate.caption)
                    .lineLimit(1)
            }
            .padding(.vertical)

            Spacer()
            Toggle("", isOn: $toggleOn)
                .labelsHidden()
                .padding(.trailing, 20)
                .onChange(of: toggleOn) { _ in
                    guard toggleOn else { return }

                    authenticate()

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                }
        }
        .frame(maxWidth: Constants.iPadMaxWidth)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 2)
                    .foregroundColor(style == .border ? Color.clear : Color("baseButton")))
        .shadow(color: Color.black.opacity(style == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
        .onAppear {
            self.toggleOn = UserDefaults.standard.bool(forKey: "biometryEnabled")

            switch(LAContext().biometryType) {
            case .none:
                lockedOutText = "Sign In"
            case .touchID:
                lockedOutText = "Touch ID"
            case .faceID:
                lockedOutText = "Face ID"
            @unknown default:
                print("unknown locked out method")
            }
        }
    }

    private func authenticate() {
        let context = LAContext()

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            let reason = "Protect your wallet. Used for signing smart contracts and transactions."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if (error != nil) {
                    toggleOn = success
                    if success {
                        self.onSuccess()
                    }
                }
            }
        }
    }

}
