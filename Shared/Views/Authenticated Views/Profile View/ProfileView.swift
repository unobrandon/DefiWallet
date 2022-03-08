//
//  ProfileView.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 2/13/22.
//

import SwiftUI
import Stinsen

struct ProfileView: View {

    private let service: AuthenticatedServices

    @ObservedObject private var store: ProfileService

    @State var showSheet: Bool = false

    init(service: AuthenticatedServices) {
        self.service = service
        self.store = service.profile
    }

    var body: some View {
        ZStack {
            Color("baseBackground").ignoresSafeArea()

            ScrollView {
                Text("It's the Profile view!!")

                RoundedButton("Log Out", style: .bordered, systemImage: "", action: {
                    self.showSheet.toggle()
                })
            }
            .confirmationDialog(service.currentUser.shortAddress,
                                isPresented: $showSheet,
                                titleVisibility: .visible) {
                Button("Logout", role: .destructive) {
                    store.logout()
                }
            } message: {
                Text("Are you sure you want to log out?")
            }
        }
        .navigationTitle("Profile")
    }

}
