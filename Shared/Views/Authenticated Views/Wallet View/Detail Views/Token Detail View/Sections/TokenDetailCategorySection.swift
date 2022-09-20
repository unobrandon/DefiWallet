//
//  TokenDetailCategorySection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 9/12/22.
//

import SwiftUI

extension TokenDetailView {

    // MARK: Token Details About Section

    @ViewBuilder
    func detailsCategorySection() -> some View {
        if let categories = categories, !categories.isEmpty {
            VStack(alignment: .leading, spacing: 10) {
                ListTitleView(title: "Categories", showDivider: false, style: service.themeStyle)

                FlexibleView(data: categories, spacing: 5, alignment: .leading) { result in
//                    if let result = result,
//                       let name = result.name {
                        Button(action: {
                            if fromMarketView {
                                marketRouter.route(to: \.categoryDetailView, result)
                            } else {
                                walletRouter.route(to: \.tokenCategoryDetail, result)
                            }
                        }, label: {
                            HStack(alignment: .center, spacing: 0) {
                                Text(result.name ?? "")
                                    .fontTemplate(FontTemplate(font: Font.system(size: 12.0), weight: .medium, foregroundColor: service.themeStyle == .shadow ? Color.white : Color("AccentColor"), lineSpacing: 0))
                                    .adjustsFontSizeToFitWidth(true)
                                    .minimumScaleFactor(0.65)
                                    .lineLimit(2)
                                Spacer()

                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .font(Font.title.weight(.semibold))
                                    .scaledToFit()
                                    .frame(height: 12, alignment: .center)
                                    .foregroundColor(service.themeStyle == .shadow ? Color.white : Color("AccentColor"))
                                    .padding(.trailing, 5)
                            }
                            .padding(.vertical, 7.5)
                            .padding(.horizontal, 12)
                            .background(RoundedRectangle(cornerRadius: 25, style: .circular)
                                .foregroundColor(Color("AccentColor").opacity(service.themeStyle == .shadow ? 1.0 : 0.15)))
                            .shadow(color: Color("AccentColor").opacity(service.themeStyle == .shadow ? 0.175 : 0.0),
                                    radius: 5, x: 0, y: 3)
                            .overlay(RoundedRectangle(cornerRadius: 25, style: .circular).strokeBorder(Color("AccentColor"), lineWidth: service.themeStyle == .shadow ? 0.0 : 0.75))
                        })
                        .buttonStyle(ClickInteractiveStyle(0.98))
//                    }
                }
                .shadow(color: Color.black.opacity(service.themeStyle == .shadow ? 0.15 : 0.0), radius: 5, x: 0, y: 3)
                .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }

}
