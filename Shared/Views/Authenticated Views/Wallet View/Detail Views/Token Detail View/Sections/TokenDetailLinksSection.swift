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
            if let blockchainURL = tokenDescriptor?.blockchainURL ?? tokenModel?.blockchainUrl ?? tokenDetails?.blockchainURL, !blockchainURL.isEmpty {
                ListStandardButton(title: "Blockchain Link", systemImage: "link", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open blockchain URL here: \(blockchainURL)")
                })
            }

            if let projectURL = tokenDescriptor?.projectURL ?? tokenModel?.projectUrl ?? tokenDetails?.projectURL, !projectURL.isEmpty {
                ListStandardButton(title: "Project Link", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project url here: \(projectURL)")
                })
            }

            if let officialForumURL = tokenDescriptor?.officialForumURL ?? tokenModel?.officialForumURL ?? tokenDetails?.officialForumURL, !officialForumURL.isEmpty {
                ListStandardButton(title: "Official Forum", systemImage: "doc.plaintext", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open official forum here: \(officialForumURL)")
                })
            }

            if let blogURL = tokenDescriptor?.blogURL ?? tokenDetails?.tokenDescriptor?.blogURL, !blogURL.isEmpty {
                ListStandardButton(title: "Blog", systemImage: "doc.append.fill", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open blog here: \(blogURL)")
                })
            }

            if let githubURL = tokenDescriptor?.githubURL ?? tokenModel?.githubUrl ?? tokenDetails?.githubURL, !githubURL.isEmpty {
                ListStandardButton(title: "GitHub", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open GitHub here: \(githubURL)")
                })
            }

            if let bitbucketURL = tokenDescriptor?.bitbucketURL ?? tokenModel?.bitbucketUrl ?? tokenDetails?.bitbucketURL, !bitbucketURL.isEmpty {
                ListStandardButton(title: "Bitbucket", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open bitbucket URL here: \(bitbucketURL)")
                })
            }
        }

        ListSection(title: "Social", hasPadding: true, style: service.themeStyle) {
            if let discordURL = tokenDescriptor?.discordURL ?? tokenModel?.discordUrl ?? tokenDetails?.discordURL, !discordURL.isEmpty {
                ListStandardButton(title: "Discord", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open discord URL here: \(discordURL)")
                })
            }

            if let telegramChannelID = tokenDescriptor?.telegramChannelID ?? tokenModel?.telegramChannelID ?? tokenDetails?.telegramChannelID, !telegramChannelID.isEmpty {
                ListStandardButton(title: "Telegram", systemImage: "safari", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open telegram URL here: https://telegram.org/\(telegramChannelID)")
                })
            }

            if let twitter = tokenDescriptor?.twitterHandle?.lowercased() ?? tokenModel?.twitterHandle?.lowercased() ?? tokenDetails?.twitterHandle?.lowercased(), !twitter.isEmpty {
                ListStandardButton(title: "@\(twitter)", localImage: "twitterLogo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project twitter here: https://twitter.com/\(twitter)")
                })
            }

            if let facebookUsername = tokenDescriptor?.facebookUsername ?? tokenModel?.facebookUsername ?? tokenDetails?.facebookUsername, !facebookUsername.isEmpty {
                ListStandardButton(title: "@\(facebookUsername)", localImage: "facebookLogo", isLast: false, hasHaptic: false, style: service.themeStyle, action: {
                    print("open project facebook here: https://facebook.com/\(facebookUsername)")
                })
            }
        }
    }

}
