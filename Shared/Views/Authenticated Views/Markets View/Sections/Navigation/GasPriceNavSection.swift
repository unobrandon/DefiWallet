//
//  GasPriceNavSection.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/17/22.
//

import SwiftUI

struct GasPriceNavSection: View {

    @ObservedObject private var service: AuthenticatedServices
    @ObservedObject private var store: MarketsService
    var action: () -> Void

    init(service: AuthenticatedServices, action: @escaping () -> Void) {
        self.service = service
        self.store = service.market
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.store.fetchEthGasPriceTrends(completion: {
                action()
            })
        }, label: {
            HStack(alignment: .center, spacing: 5) {
                if let gas = store.ethGasPriceTrends,
                   let trends = gas.trend,
                   let _ = gas.current?.standard {
                    LightChartView(data: trends[0...8].map({ $0.baseFee ?? 0 }).reversed(),
                                   type: .curved,
                                   visualType: .filled(color: .purple, lineWidth: 2.5),
                                   offset: 0.2,
                                   currentValueLineType: .none)
                            .frame(width: 40, height: 24, alignment: .center)
                }

                if let gas = store.gasSocketPrices?.standard,
                   let formatedGas = gas / 1000000000 {
                    MovingNumbersView(number: formatedGas, numberOfDecimalPlaces: 0,  fixedWidth: nil, animationDuration: 0.5, showComma: false) { gas in
                        Text(gas).fontTemplate(DefaultTemplate.gasPriceFont)
                    }
                    .mask(AppGradients.movingNumbersMask)
                    .padding(.trailing, 2.5)
                }

                Image(systemName: "fuelpump.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 18, alignment: .center)
                    .foregroundColor(.primary)
            }
        })
    }

}
