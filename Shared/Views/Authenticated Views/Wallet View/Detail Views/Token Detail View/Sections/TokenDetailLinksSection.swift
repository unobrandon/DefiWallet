//
//  TokenDetailLinksSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/11/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Links About Section

    @ViewBuilder
    func detailsLinksSection() -> some View {
        ListSection(title: "Links", hasPadding: true, style: service.themeStyle) {
            if let blockchainURL = tokenDescriptor?.blockchainURL?.filter { $0 != "" } ?? tokenModel?.blockchainUrl?.filter { $0 != "" } ?? tokenDetails?.blockchainURL?.filter { $0 != "" }, !blockchainURL.isEmpty {
                ListStandardButton(title: "Blockchain Links", systemImage: "link", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if blockchainURL.count == 1 {
                        walletRouter.route(to: \.safari, (blockchainURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Blockchain Links", links: blockchainURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let projectURL = tokenDescriptor?.projectURL?.filter { $0 != "" } ?? tokenModel?.projectUrl?.filter { $0 != "" } ?? tokenDetails?.projectURL?.filter { $0 != "" }, !projectURL.isEmpty {
                ListStandardButton(title: "Project Links", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if projectURL.count == 1 {
                        walletRouter.route(to: \.safari, (projectURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Project Links", links: projectURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let officialForumURL = tokenDescriptor?.officialForumURL?.filter { $0 != "" } ?? tokenModel?.officialForumURL?.filter { $0 != "" } ?? tokenDetails?.officialForumURL?.filter { $0 != "" }, !officialForumURL.isEmpty {
                ListStandardButton(title: "Official Forum", systemImage: "doc.plaintext", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if officialForumURL.count == 1 {
                        walletRouter.route(to: \.safari, (officialForumURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Official Forums", links: officialForumURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let blogURL = tokenDescriptor?.blogURL?.filter { $0 != "" } ?? tokenDetails?.tokenDescriptor?.blogURL?.filter { $0 != "" }, !blogURL.isEmpty {
                ListStandardButton(title: "Blog", systemImage: "doc.append.fill", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if blogURL.count == 1 {
                        walletRouter.route(to: \.safari, blogURL.first ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Blogs", links: blogURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let githubURL = tokenDescriptor?.githubURL?.filter { $0 != "" } ?? tokenModel?.githubUrl?.filter { $0 != "" } ?? tokenDetails?.githubURL?.filter { $0 != "" }, !githubURL.isEmpty {
                ListStandardButton(title: "GitHub", localImage: "github_logo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if githubURL.count == 1 {
                        walletRouter.route(to: \.safari, (githubURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Github", links: githubURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let bitbucketURL = tokenDescriptor?.bitbucketURL?.filter { $0 != "" } ?? tokenModel?.bitbucketUrl?.filter { $0 != "" } ?? tokenDetails?.bitbucketURL?.filter { $0 != "" }, !bitbucketURL.isEmpty {
                ListStandardButton(title: "Bitbucket", localImage: "bitbucket_logo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if bitbucketURL.count == 1 {
                        walletRouter.route(to: \.safari, (bitbucketURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Bitbucket", links: bitbucketURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }
        }

        ListSection(title: "Social", hasPadding: true, style: service.themeStyle) {
            if let discordURL = tokenDescriptor?.discordURL?.filter { $0 != "" } ?? tokenModel?.discordUrl?.filter { $0 != "" } ?? tokenDetails?.discordURL?.filter { $0 != "" }, !discordURL.isEmpty {
                ListStandardButton(title: "Discord", localImage: "discord_logo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    if discordURL.count == 1 {
                        walletRouter.route(to: \.safari, (discordURL.first ?? "") ?? "")
                    } else {
                        SOCManager.present(isPresented: $openLinkSheet) {
                            MultipleLinksView(title: "Discord", links: discordURL, service: service, action: { link in
                                SOCManager.dismiss(isPresented: $openLinkSheet)
                                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                                    walletRouter.route(to: \.safari, link)
                                }
                            })
                        }
                    }
                })
            }

            if let telegramChannelID = tokenDescriptor?.telegramChannelID ?? tokenModel?.telegramChannelID ?? tokenDetails?.telegramChannelID, !telegramChannelID.isEmpty {
                ListStandardButton(title: "Telegram", localImage: "telegram_logo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open telegram URL here: https://t.me/\(telegramChannelID)")
                    walletRouter.route(to: \.safari, "https://t.me/" + telegramChannelID)
                })
            }

            if let twitter = tokenDescriptor?.twitterHandle?.lowercased() ?? tokenModel?.twitterHandle?.lowercased() ?? tokenDetails?.twitterHandle?.lowercased(), !twitter.isEmpty {
                ListStandardButton(title: "@\(twitter)", localImage: "twitterLogo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project twitter here: https://twitter.com/\(twitter)")
                    walletRouter.route(to: \.safari, "https://twitter.com/" + twitter)
                })
            }

            if let facebookUsername = tokenDescriptor?.facebookUsername?.lowercased() ?? tokenModel?.facebookUsername?.lowercased() ?? tokenDetails?.facebookUsername?.lowercased(), !facebookUsername.isEmpty {
                ListStandardButton(title: "@\(facebookUsername)", localImage: "facebookLogo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project facebook here: https://facebook.com/\(facebookUsername)")
                    walletRouter.route(to: \.safari, "https://facebook.com/" + facebookUsername)
                })
            }
        }
    }

}
