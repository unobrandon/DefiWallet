//
//  WalletCoordinator.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

final class WalletCoordinator: NavigationCoordinatable {

    let stack = NavigationStack(initial: \WalletCoordinator.start)

    @Root var start = makeStart
    @Route(.push) var sendTo = makeSendTo
    @Route(.push) var sendToDetail = makeSendToDetail
    @Route(.push) var swapToken = makeSwapToken
    @Route(.push) var swapTokenDetail = makeSwapTokenDetail
    @Route(.modal) var swapListToken = makeSwapListToken
    @Route(.push) var networkDetail = makeNetworkDetail
    @Route(.push) var history = makeHistory
    @Route(.push) var tokens = makeTokens
    @Route(.push) var collectables = makeCollectables
    @Route(.push) var historyDetail = makeHistoryDetail
    @Route(.push) var tokenDetail = makeTokenDetail
    @Route(.push) var tokenDetails = makeTokenDetails
    @Route(.push) var tokenExternalDetail = makeExternalTokenDetail
    @Route(.push) var tokenDescriptorDetail = makeDescriptorTokenDetail
    @Route(.push) var tokenCategoryDetail = makeTokenCategoryDetail
    @Route(.modal) var safari = makeSafari

    let currentUser: CurrentUser
    let services: AuthenticatedServices

    init(currentUser: CurrentUser, services: AuthenticatedServices) {
        self.currentUser = currentUser
        self.services = services
    }

    deinit {
        print("de-init WomeCoordinator")
    }

}
