//
//  TransactButtonView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/15/22.
//

import SwiftUI

struct TransactButtonView: View {

    private var style: AppStyle

    private let enableDeposit: Bool
    private let enableSend: Bool
    private let enableReceive: Bool
    private let enableSwap: Bool

    private let actionDeposit: () -> Void
    private let actionSend: () -> Void
    private let actionReceive: () -> Void
    private let actionSwap: () -> Void

    init(style: AppStyle, enableDeposit: Bool, enableSend: Bool, enableReceive: Bool, enableSwap: Bool,
         actionDeposit: @escaping () -> Void,
         actionSend: @escaping () -> Void,
         actionReceive: @escaping () -> Void,
         actionSwap: @escaping () -> Void) {
        self.style = style
        self.enableDeposit = enableDeposit
        self.enableSend = enableSend
        self.enableReceive = enableReceive
        self.enableSwap = enableSwap
        self.actionDeposit = actionDeposit
        self.actionSend = actionSend
        self.actionReceive = actionReceive
        self.actionSwap = actionSwap
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            if enableDeposit {
                Spacer()

                TransactButton(title: "Deposit", systemImage: Constants.currencyCircleImage, size: 46, style: style, action: {
                    actionDeposit()
                })
            }

            if enableSend {
                Spacer()

                TransactButton(title: "Send", systemImage: "paperplane.fill", size: 46, style: style, action: {
                    actionSend()
                })
            }

            if enableReceive {
                Spacer()

                TransactButton(title: "Receive", systemImage: "arrow.down.circle", size: 46, style: style, action: {
                    actionReceive()
                })
            }

            if enableSwap {
                Spacer()

                TransactButton(title: "Swap", systemImage: "arrow.left.arrow.right", size: 46, style: style, action: {
                    actionSwap()
                })
            }

            Spacer()
        }
        .frame(maxWidth: Constants.iPadMaxWidth)
        #if os(iOS)
        .frame(maxWidth: MobileConstants.screenWidth)
        #endif
    }

}
