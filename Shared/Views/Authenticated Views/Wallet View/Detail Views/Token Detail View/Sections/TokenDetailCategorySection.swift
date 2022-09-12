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
        if let categories = tokenModel?.categories?.filter({ $0 != "" }) {
            VStack(alignment: .leading, spacing: 10) {
                Text("Categories:")
                    .font(.caption)
                    .fontWeight(.regular)
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                LazyVGrid(columns: categoriesColumns, spacing: 5) {
                    ForEach(categories, id: \.self) { name in
                        if let name = name {
                            Button(action: {
                                print("go to category")
                            }, label: {
                                HStack(alignment: .top, spacing: 0) {
                                    Text(name)
                                        .fontTemplate(FontTemplate(font: Font.system(size: 12.0), weight: .medium, foregroundColor: .primary, lineSpacing: 0))
                                        .adjustsFontSizeToFitWidth(true)
                                        .minimumScaleFactor(0.65)
                                        .lineLimit(2)
                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .font(Font.title.weight(.semibold))
                                        .scaledToFit()
                                        .frame(width: 6, height: 12, alignment: .center)
                                        .foregroundColor(.secondary)
                                        .padding(.trailing, 5)
                                }
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10, style: .circular)
                                    .foregroundColor(Color("baseButton_selected")))
                                .shadow(color: Color("baseButton_selected").opacity(service.themeStyle == .shadow ? 0.175 : 0.0),
                                        radius: 5, x: 0, y: 3)
                            })
                            .buttonStyle(ClickInteractiveStyle(0.98))
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
            .padding(.bottom, 30)
            .padding(.horizontal)
        }
    }

}
