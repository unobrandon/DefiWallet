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

    @ObservedObject private var store: UnauthenticatedServices

    @State var textViewText: String = ""
    @State var isLoading: Bool = false
    @State var isSuccess: Bool = false
    @State var disablePrimaryAction: Bool = true
    @State var invalidPhrase: Bool = false
    @State var attempts: Int = 0

    init(services: UnauthenticatedServices) {
        self.store = services
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 10) {
                Spacer()

                Image(systemName: "folder.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .font(Font.title.weight(.medium))
                    .frame(width: 46, height: 46, alignment: .center)
                    .padding(.bottom, 10)
                    .irregularGradient(colors: [.blue, .orange, .red, .yellow], backgroundColor: .pink, speed: 4)

                Text("Restore an existing wallet with your 12 or 24-word secret recovery phrase.")
                    .fontTemplate(DefaultTemplate.subheadingSemiBold)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)

                Spacer()
                TextViewInteractiveBordered(text: $textViewText, hasError: $invalidPhrase,
                                            placeholder: "enter 12 or 24-word recovery phrase here",
                                            errorMessage: "invalid secret phrase, please try again",
                                            textLimit: nil, maxHeight: 100, onCommit: {
                    guard !isLoading, !isSuccess else { return }

                    submitInput()
                })
                .modifier(Shake(animatableData: CGFloat(attempts)))
                .frame(maxWidth: Constants.iPadMaxWidth)
                .onChange(of: textViewText, perform: { text in
                    enablePrimaryButton(text)
                })

                HStack(alignment: .top, spacing: 5) {
                    Text("secret recovery phrases are stored offline on your local device.")
                        .fontTemplate(DefaultTemplate.caption)
                        .multilineTextAlignment(.leading)

                    Spacer()
                    Button(action: {
                        self.textViewText = store.pasteText()

                        #if os(iOS)
                            HapticFeedback.successHapticFeedback()
                        #endif
                    }, label: {
                        Label("Paste", systemImage: "doc.on.clipboard.fill")
                    })
                    .buttonStyle(.bordered)
                    .controlSize(.mini)
                    .buttonBorderShape(.roundedRectangle)
                    .disabled(!disablePrimaryAction)
                }
                .frame(maxWidth: 640)

                Spacer()
                if isLoading {
                    LoadingIndicator(size: 36).padding(.bottom, 10)
                } else if isSuccess {
                    CheckmarkView(size: 42, color: .green)
                        .padding(.bottom, 10)
                } else {
                    RoundedInteractiveButton("Import Wallet", isDisabled: $disablePrimaryAction, style: .primary, systemImage: "arrow.down.to.line", action: {
                        submitInput()
                    }).padding(.bottom, 10)
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle("Import Wallet", displayMode: .inline)
    }

    private func enablePrimaryButton(_ text: String) {
        guard let count = textViewText.countWords(),
                count == 12 ||
                count == 24 ||
                textViewText.count == 64 else {
            disablePrimaryAction = true
            invalidPhrase = false
            return
        }

        disablePrimaryAction = false
    }

    private func submitInput() {
        guard !disablePrimaryAction else {
            #if os(iOS)
                HapticFeedback.errorHapticFeedback()
            #endif

            return
        }

        isLoading = true
        textViewText = textViewText.cleanUpPastedText()
        isSuccess = false

        store.checkPhraseValid(textViewText, completion: { isValid in
            isLoading = false

            if isValid {
                invalidPhrase = false
                isSuccess = true

                #if os(iOS)
                    HapticFeedback.successHapticFeedback()
                #endif

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    unauthenticatedRouter.route(to: \.setPassword)
                    isSuccess = true
                }
            } else {
                invalidPhrase = true
                isSuccess = false
                withAnimation(.easeOut(duration: 0.32)) {
                    attempts += 1
                }

                #if os(iOS)
                    HapticFeedback.errorHapticFeedback()
                #endif
            }
        })
    }

}
