//
//  GlobalDataNavSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/9/22.
//

import SwiftUI

struct GlobalDataNavSection: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    @State var data: GlobalMarketData
    var action: () -> Void

    init(data: GlobalMarketData, service: AuthenticatedServices, action: @escaping () -> Void) {
        self.data = data
        self.service = service
        self.store = service.market
        self.action = action
    }

    var body: some View {
        Button(action: { action() }, label: {
            HStack(alignment: .center, spacing: 5) {
                Image(systemName: "globe.americas")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24, alignment: .center)
                    .font(Font.title.weight(.medium))
                    .padding(.trailing, 5)

                VStack(alignment: .leading, spacing: 0) {
                    if let num = data.totalMarketCap?[service.currentUser.currency] {
                        HStack(alignment: .center, spacing: 0) {
                            Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.bodyBold)

                            Text("".formatLargeDoubleNumber(num, size: .regular, scale: 2)).fontTemplate(DefaultTemplate.bodyBold)
                        }
                    }

                    if let percent = data.marketCapChangePercentage24HUsd {
                        Text((percent >= 0 ? "▲ " : "▼ ") +
                             "\("".forTrailingZero(temp: percent.truncate(places: 2)))%")
                            .fontTemplate(FontTemplate(font: Font.system(size: 13.0), weight: .bold, foregroundColor: percent >= 0 ? .green : .red, lineSpacing: 0))
                    }
                }
            }
        })
        .buttonStyle(ClickInteractiveStyle(0.975))
    }

}
