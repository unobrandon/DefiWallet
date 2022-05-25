//
//  StackedStatisticLabel.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 5/24/22.
//

import SwiftUI

struct StackedStatisticLabel: View {

    private let title: String
    private let metric: String?
    private let number: Double?
    private let percent: String?
    private let percentColor: Color?
    private var style: AppStyle?

    init(title: String, metric: String? = nil, number: Double? = nil, percent: String? = nil, percentColor: Color? = nil, style: AppStyle? = nil) {
        self.title = title
        self.metric = metric
        self.number = number
        self.percent = percent
        self.percentColor = percentColor
        self.style = style
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).fontTemplate(DefaultTemplate.caption)

            if let metric = metric {
                Text(metric).fontTemplate(DefaultTemplate.metricFont)
            }

            if let number = number {
                HStack(alignment: .center, spacing: 1) {
                    Text(Locale.current.currencySymbol ?? "").fontTemplate(DefaultTemplate.metricFont)

                    MovingNumbersView(number: number,
                                      numberOfDecimalPlaces: number.decimalCount() < 3 ? number.decimalCount() : 3,
                                      fixedWidth: nil,
                                      showComma: true) { str in
                        Text(str).fontTemplate(DefaultTemplate.metricFont)
                    }
                }.mask(AppGradients.movingNumbersMask)
            }

            if let percent = percent,
               let percentColor = percentColor,
               let style = style {
                ProminentRoundedLabel(text: percent, color: percentColor, style: style)
            }

            Spacer()
        }
    }

}
