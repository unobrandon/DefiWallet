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
        BaseBackgroundColor(style: service.themeStyle, {
            ScrollView(.vertical, showsIndicators: false) {

                ListSection(style: service.themeStyle) {
                    ListButtonHeader(name: service.currentUser.shortAddress, localImage: "welcomeCarouselThree", style: service.themeStyle, action: {
                        print("edit profile")
                    })
                }

                ListSection(title: "General", style: service.themeStyle) {
                    ListButtonStandard(title: "ENS Domain", systemImage: "person", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListButtonStandard(title: "Currency", systemImage: "dollarsign.square", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListButtonStandard(title: "Language", systemImage: "text.quote", isLast: false, style: service.themeStyle, action: {
                        print("Currency")
                    })

                    ListButtonStandard(title: "Appearance", systemImage: "paintbrush.pointed", isLast: true, style: service.themeStyle, action: {
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
                    ListButtonStandard(title: "Sensitive Info", systemImage: "eye", isLast: false, style: service.themeStyle, action: {
                        print("Sensitive")
                    })

                    ListButtonStandard(title: "Secret Phrase", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("Secret")
                    })

                    ListButtonStandard(title: "Face ID", systemImage: "faceid", isLast: false, style: service.themeStyle, action: {
                        print("Face")
                    })

                    ListButtonStandard(title: "Auto Lock", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                        print("Auto")
                    })
                }

                ListSection(title: "Support", style: service.themeStyle) {
                    ListButtonStandard(title: "website.io", systemImage: "safari", isLast: false, style: service.themeStyle, action: {
                        print("website")
                    })

                    ListButtonStandard(title: "FAQ & Support", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("FAQ")
                    })

                    ListButtonStandard(title: "Rate Us", systemImage: "star", isLast: false, style: service.themeStyle, action: {
                        print("Rate")
                    })

                    ListButtonStandard(title: "Discord", systemImage: "lock", isLast: false, style: service.themeStyle, action: {
                        print("Discord")
                    })

                    ListButtonStandard(title: "Twitter", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
                        print("Twitter")
                    })
                }

                ListSection(title: "More", style: service.themeStyle) {
                    ListButtonStandard(title: "Advanced", systemImage: "eye", isLast: false, style: service.themeStyle, action: {
                        print("Sensitive")
                    })

                    ListButtonStandard(title: "Terms of Service", systemImage: "square.text.square", isLast: false, style: service.themeStyle, action: {
                        print("Secret")
                    })

                    ListButtonStandard(title: "Privacy Policy", systemImage: "faceid", isLast: false, style: service.themeStyle, action: {
                        print("Face")
                    })

                    ListButtonStandard(title: "EULA Agreement", systemImage: "lock", isLast: false, style: service.themeStyle, action: {
                        print("Auto")
                    })

                    ListButtonStandard(title: "Log Out", systemImage: "lock", isLast: true, style: service.themeStyle, action: {
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
                    store.logout()
                }
            } message: { Text("Are you sure you want to log out?") }
        })
        .navigationTitle("Profile")
    }

}
