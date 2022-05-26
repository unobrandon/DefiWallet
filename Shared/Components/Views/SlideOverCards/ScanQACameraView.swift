//
//  ScanCameraView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/20/22.
//

import SwiftUI
import SwiftUIX

struct ScanQACameraView: View {

    @ObservedObject private var store: WalletService

    @Binding var foundLink: Bool
    @State private var torchIsOn = false
    @State private var sessionExpired = false
    @State private var attempts: Int = 0

    init(foundLink: Binding<Bool>, service: AuthenticatedServices) {
        self.store = service.wallet
        self._foundLink = foundLink
    }

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            ZStack(alignment: .bottomTrailing) {
                CBScanner(supportBarcode: .constant([.qr, .code128]), torchLightIsOn: self.$torchIsOn, scanInterval: .constant(0.5)) {
                    guard !self.foundLink else { return }

                    store.connectDapp(uri: $0.value, completion: { success in
                        if success, store.wcProposal?.proposer.name != nil {
                            HapticFeedback.successHapticFeedback()
                            self.foundLink = true
                            self.sessionExpired = false
                        } else {
                            guard !success, !sessionExpired else {
                                self.sessionExpired = true

                                return
                            }

                            self.attempts += 1
                        }
                    })

                    print("have received incoming link!: \(String(describing: $0.value))")
                }
                #if os(macOS)
                .frame(height: 400, alignment: .center)
                #elseif os(iOS)
                .frame(minHeight: MobileConstants.screenWidth - 80, maxHeight: MobileConstants.screenWidth - 40, alignment: .center)
                #endif
                .modifier(Shake(animatableData: CGFloat(attempts)))
                .foregroundColor(Color("baseBackground"))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 0)

                Button(action: {
                    self.torchIsOn.toggle()
                    HapticFeedback.rigidHapticFeedback()
                }, label: {
                    ZStack {
                        VisualEffectBlurView(blurStyle: .systemUltraThinMaterial)
                            .frame(width: 50, height: 50)
                            .cornerRadius(15)
                            .foregroundColor(Color("baseBackground"))
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)

                        Image(systemName: self.torchIsOn ? "lightbulb.fill" : "lightbulb.slash.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.primary)
                            .frame(width: 25, height: 25, alignment: .center)
                    }
                })
                .padding(.all, 15)
                .buttonStyle(ClickInteractiveStyle(0.97))
            }

            if sessionExpired {
                Text("session expired, please refresh QR code").fontTemplate(DefaultTemplate.captionError)
            }
        }
    }

}
