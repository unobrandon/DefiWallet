//
//  InvestService.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/17/22.
//

import Foundation
import RealmSwift

class InvestService: ObservableObject {

    @ObservedResults(TaskItem.self) var tasks

}
