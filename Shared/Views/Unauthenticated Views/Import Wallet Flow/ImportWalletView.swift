//
//  ImportWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI
import Stinsen

struct ImportWalletView: View {

    @EnvironmentObject private var unauthenticatedRouter: UnauthenticatedCoordinator.Router

    private let services: UnauthenticatedServices

    @ObservedObject private var store: UserOnboardingServices

    @State var textViewText: String = ""
    @State var disableImport: Bool = true

    init(services: UnauthenticatedServices) {
        self.services = services
        self.store = services.userOnboarding
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                TextViewBordered(text: $textViewText, placeholder: "enter your 12 or 24 word seed phrase or secret phrase here", textLimit: nil, maxHeight: 100, onCommit: {
                    print("commit ed")
                })
                .frame(maxWidth: 640)
                .onChange(of: textViewText, perform: { text in
                    disableImport = text.isEmpty
                })

                HStack {
                    Text("seed phrases and private keys are never uploaded and are only stored offline on your device.")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    Button(action: {
                        self.textViewText = services.pasteText()

                        #if os(iOS)
                            HapticFeedback.rigidHapticFeedback()
                        #endif
                    }, label: {
                        Label("Paste", systemImage: "doc.on.clipboard.fill")
                    })
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                    .buttonBorderShape(.roundedRectangle)
                    .disabled(!disableImport)
                }
                .frame(maxWidth: 640)

                Spacer()
                TermsOfServiceButton(action: {
                    unauthenticatedRouter.route(to: \.terms)
                })

                RoundedInteractiveButton("Import Wallet", isDisabled: $disableImport, style: .primary, systemImage: "arrow.down.to.line", action: {
                    #if os(iOS)
                    guard let count = textViewText.countWords() else {
                        print("no words entered")
                        return
                    }

                    let clean = textViewText.cleanUpPastedText()
                    if count.isMultiple(of: 12) {
                        print("Success importing wallet! Word count is: \(count). Cleaned up: \(clean)")
                        HapticFeedback.successHapticFeedback()
                    } else {
                        print("error importing wallet. Word count is: \(count). Cleaned up: \(clean)")
                        HapticFeedback.errorHapticFeedback()
                    }
                    #endif
                })
                .padding(.bottom, 10)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Import Wallet")
    }
}
