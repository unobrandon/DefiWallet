//
//  StickyHeaderView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/5/22.
//

import SwiftUI

struct StickyHeaderView: View {

    private let title: String
    private let subtitle: String
    private var style: AppStyle
    private let localTitleImage: String?
    private let remoteTitleImage: String?
    private let localImage: String?
    private let remoteImage: String?

    init(title: String, subtitle: String, style: AppStyle,
         localTitleImage: String? = nil, remoteTitleImage: String? = nil,
         localImage: String? = nil, remoteImage: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.localTitleImage = localTitleImage
        self.remoteTitleImage = remoteTitleImage
        self.localImage = localImage
        self.remoteImage = remoteImage
    }

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll_sticky_header")).minY
            let size = proxy.size
            let height = (size.height + minY)

            if let localImage = localImage {
                Image(localImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: height > 0 ? height : 0,alignment: .top)
                    .overlay(content: { backgroundOverlayView().animation(.none) })
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(style == .shadow ? 0.25 : 0.0), radius: 12, x: 0, y: 15)
                    .offset(y: -minY)
            } else if let remoteImage = remoteImage {
                RemoteImage(remoteImage, size: size.width,
                            fullSize: CGSize(width: size.width, height: height > 0 ? height : 0))
                    .overlay(content: { backgroundOverlayView().animation(.none) })
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(style == .shadow ? 0.25 : 0.0), radius: 12, x: 0, y: 15)
                    .offset(y: -minY)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .irregularGradient(colors: [.orange, .red, .yellow, .orange, .red, .yellow], backgroundColor: .pink, speed: 4)
                    .frame(width: size.width, height: height > 0 ? height : 0,alignment: .top)
                    .overlay(content: { backgroundOverlayView().animation(.none) })
                    .shadow(color: Color.black.opacity(style == .shadow ? 0.25 : 0.0), radius: 12, x: 0, y: 15)
                    .offset(y: -minY)
            }
        }
        .frame(height: 200)
    }

    @ViewBuilder
    func backgroundOverlayView() -> some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.clear, .systemBackground.opacity(0.85)], startPoint: .top, endPoint: .bottom).cornerRadius(20)

            VStack(alignment: .leading, spacing: 10) {
                if let localTitleImage = localTitleImage {
                    Image(localTitleImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 64, height: 64, alignment: .center)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 1))
                        .shadow(color: Color.black.opacity(style == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)
                } else if let remoteTitleImage = remoteTitleImage {
                    RemoteImage(remoteTitleImage, size: 64)
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 1))
                        .shadow(color: Color.black.opacity(style == .shadow ? 0.15 : 0.0), radius: 8, x: 0, y: 6)
                }

                Text(title).fontTemplate(DefaultTemplate.titleSemiBold)
                Text(subtitle).fontTemplate(DefaultTemplate.bodyMedium)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

}
