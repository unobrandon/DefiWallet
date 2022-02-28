//
//  CreateWalletView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct CreateWalletView: View {

    private let services: UnauthenticatedServices

    @ObservedObject private var store: UserOnboardingServices

    @State var doneGenerating: Bool = false

    init(services: UnauthenticatedServices) {
        self.services = services
        self.store = services.userOnboarding
    }

    var body: some View {
        // Play generating animation & show the 'username' +
        // explanation behind subdomain
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            VStack(alignment: .center, spacing: 20) {
                LoadingIndicator()

                RoundedButton("Show Noti", style: .secondary, systemImage: "paperplane.fill", action: {
                    showNotiHUD(image: "wifi", color: .blue, title: "Connected", subtitle: "")
                })

                TextFieldSingleBordered(text: "", placeholder: "username", systemImage: "person.crop.circle", textLimit: 20, onEditingChanged: { text in
                    print("text changed: \(text)")
                }, onCommit: {
                    print("returned username ehh")
                })

                ListSection(title: "Hello Crypto", style: .shadow) {
                    TextFieldSingleList(text: "", placeholder: "enter 12 or 24 seed phrase here", systemImage: "list.bullet.rectangle", textLimit: nil, isLast: true, onEditingChanged: { text in
                        print(text)
                    }, onCommit: {
                        print("commit ed")
                    })
                }

                ListSection(title: "Hello World", style: .shadow) {
                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: false, style: .shadow, action: {
                        print("Come")
                    })

                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: true, style: .shadow, action: {
                        print("Come")
                    })
                }

                ListSection(title: "Hello World", style: .border) {
                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: false, style: .border, action: {
                        print("Come")
                    })

                    ListButtonStandard(title: "Come one man", systemImage: "safari", isLast: true, style: .border, action: {
                        print("Come")
                    })
                }

            }
        }
        .navigationTitle("Create Wallet")
        #if os(iOS)
        .navigationBarBackButtonHidden(!doneGenerating)
        #endif
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + services.userOnboarding.generateWalletDelay) {
                doneGenerating = true
            }
        }
    }
}
