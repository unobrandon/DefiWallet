//
//  InvestView.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 2/14/22.
//

import SwiftUI
import Stinsen
import RealmSwift

struct InvestView: View {

    private let services: AuthenticatedServices

    @ObservedObject private var store: InvestService

    @ObservedResults(TaskItem.self, sortDescriptor: SortDescriptor.init(keyPath: "taskDate", ascending: false)) var tasksFetched

    init(services: AuthenticatedServices) {
        self.services = services
        self.store = services.invest
    }

    var body: some View {
        ScrollView {
            Text("It's the Investment view!!")

            RoundedButton("Add new man", style: .secondary, systemImage: nil, action: {
                let task = TaskItem()
                task.taskTitle = "usernameHere"
                task.taskDate = Date()
                $tasksFetched.append(task)
            })

            RoundedButton("Add", style: .primary, systemImage: nil, action: {
                let task = TaskItem()
                task.taskTitle = "TestYOUUU"
                task.taskDate = Date()
                $tasksFetched.append(task)
            })

            ForEach(tasksFetched) { task in
                Text(task.taskTitle)
                    .fontTemplate(DefaultTemplates.body)
                    .animation(.easeInOut, value: tasksFetched)
                    .padding()
            }
        }
        .navigationTitle("Invest")
    }

}
