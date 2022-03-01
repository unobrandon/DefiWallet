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

                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 46, height: 46, alignment: .center)
                    .irregularGradient(colors: [.blue, .orange, .red, .yellow], backgroundColor: .pink, speed: 4)

                Text("Restore an existing wallet with your 12 or 24-word secret recovery phrase.")
                    .fontTemplate(DefaultTemplate.subheadingBold)
                    .multilineTextAlignment(.leading)

                Spacer()
                TextViewBordered(text: $textViewText, placeholder: "enter 12 or 24-word recovery phrase here", textLimit: nil, maxHeight: 100, onCommit: {
                    print("commit ed")
                })
                .frame(maxWidth: Constants.iPadMaxWidth)
                .onChange(of: textViewText, perform: { text in
                    enablePrimaryButton(text: text)
                })

                HStack(alignment: .top, spacing: 5) {
                    Text("seed phrases and private keys are only stored offline on your device.")
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
                RoundedInteractiveButton("Import Wallet", isDisabled: self.$disableImport, style: .primary, systemImage: "arrow.down.to.line", action: {
                    if !disableImport {
                        #if os(iOS)
                            HapticFeedback.successHapticFeedback()
                        #endif
                    } else {
                        #if os(iOS)
                            HapticFeedback.errorHapticFeedback()
                        #endif
                    }
                })
                .padding(.bottom, 10)
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Import Wallet", displayMode: .inline)
    }

    private func enablePrimaryButton(text: String) {
        guard let count = textViewText.countWords() else {
            disableImport = false
            return
        }

        if count.isMultiple(of: 12) || textViewText.count == 64 {
            disableImport = true
        } else {
            disableImport = false
        }
    }

}
