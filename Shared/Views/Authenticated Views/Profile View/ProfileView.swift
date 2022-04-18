//
//  ProfileView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct ProfileView: View {

    @ObservedObject private var service: AuthenticatedServices

    @ObservedObject private var store: ProfileService

    @State var showSheet: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.profile
    }

    var body: some View {
        BackgroundColorView(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {

                ListSection(style: service.themeStyle) {
                    ProfileHeaderButton(name: service.currentUser.shortAddress, style: service.themeStyle, user: service.currentUser, action: {
                        print("edit profile")
                    })
                }

                ListSection(title: nil, style: service.themeStyle) {
                }

                ListSection(title: "General", style: service.themeStyle) {
                    ListStandardButton(title: "ENS Domain", systemImage: "person", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListStandardButton(title: "Currency", systemImage: Constants.currencySquareImage, isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListStandardButton(title: "Language", systemImage: "text.quote", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListStandardButton(title: "Appearance", systemImage: "paintbrush.pointed", isLast: true, style: service.themeStyle, action: {
                        print("Currency")
                        if service.themeStyle == .shadow {
                            withAnimation(.easeInOut) {
                                service.themeStyle = .border
                            }
                        } else if service.themeStyle == .border {
                            withAnimation(.easeInOut) {
                                service.themeStyle = .shadow
                            }
                        }
                    })
                }

                ListSection(title: "Security & Privacy", style: service.themeStyle) {
                    ListStandardButton(title: "Sensitive Info", systemImage: "eye", isLast: false, style: service.themeStyle, action: {
                        print("Sensitive")
                    })

                    ListStandardButton(title: "Secret Phrase", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("Secret")
                    })

                    ListStandardButton(title: "Face ID", systemImage: "faceid", isLast: false, style: service.themeStyle, action: {
                        print("Face")
                    })

                    ListStandardButton(title: "Auto Lock", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                        print("Auto")
                    })
                }

                ListSection(title: "Support", style: service.themeStyle) {
                    ListStandardButton(title: "website.io", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                        print("website")
                    })

                    ListStandardButton(title: "FAQ & Support", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("FAQ")
                    })

                    ListStandardButton(title: "Rate Us", systemImage: "star", isLast: false, style: service.themeStyle, action: {
                        print("Rate")
                    })

                    ListStandardButton(title: "Discord", systemImage: "lock", isLast: false, style: service.themeStyle, action: {
                        print("Discord")
                    })

                    ListStandardButton(title: "Twitter", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                        print("Twitter")
                    })
                }

                ListSection(title: "More", style: service.themeStyle) {
                    ListStandardButton(title: "Advanced", systemImage: "eye", isLast: false, style: service.themeStyle, action: {
                        print("Sensitive")
                    })

                    ListStandardButton(title: "Terms of Service", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("Secret")
                    })

                    ListStandardButton(title: "Privacy Policy", systemImage: "faceid", isLast: false, style: service.themeStyle, action: {
                        print("Face")
                    })

                    ListStandardButton(title: "EULA Agreement", systemImage: "lock", isLast: false, style: service.themeStyle, action: {
                        print("Auto")
                    })

                    ListStandardButton(title: "Log Out", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                        self.showSheet.toggle()
                    })
                }

                FooterInformation(middleText: "made with ♥ in nyc")
                    .padding(.vertical)
            }
            .confirmationDialog(service.currentUser.shortAddress,
                                isPresented: $showSheet,
                                titleVisibility: .visible) {
                Button("Logout", role: .destructive) {
                    store.logout(service.currentUser.sessionToken)
                }
            } message: { Text("Are you sure you want to log out?") }
        })
        .navigationTitle("Profile")
    }

}
