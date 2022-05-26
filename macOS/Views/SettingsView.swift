//
//  SettingsView.swift
//  DefiWallet (macOS)
//
//  Created by Brandon Shaw on 2/26/22.
//

import SwiftUI

struct SettingsView: View {

    @State var showAlert = false

    var body: some View {
        VStack(alignment: .center, spacing: 20) {

            Image("settings_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)

            Text("DefiWallet")
                .font(.largeTitle)

            Text("version \(MacConstants.appVersion)")

            Text("made with ❤ in NYC")

            RoundedButton("Sure", style: .primary, systemImage: "paperplane.fill", action: {
                showAlert.toggle()
            })
        }
        .frame(width: 400, height: 260)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Are you sure?")
                    .font(.title)
                    .foregroundColor(.red),
                message: Text("This action cannot be undone."),
                primaryButton: .cancel(),
                secondaryButton: .destructive(
                    Text("Clear"),
                    action: {
                        showAlert.toggle()
                    }))
        }
    }

}
