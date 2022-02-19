//
//  Wallet.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/15/22.
//

import Foundation
import RealmSwift

final class TaskItem: Object, Identifiable {

    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var taskTitle: String
    @Persisted var taskDate: Date = Date()

}

final class Group: Object, ObjectKeyIdentifiable {
    /// The unique ID of the Group. `primaryKey: true` declares the
    /// _id member as the primary key to the realm.
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var items = RealmSwift.List<TaskItem>()
    //@Persisted var currentUser = RealmSwift.List<TaskItem>().first?
}

struct Wallet {
    let address: String
    let data: Data
    let name: String
    let isHD: Bool
}

struct HDKey {
    let name: String?
    let address: String
}

enum SeedStrength {
    case twelveWords
    case twentyFourWords
}
