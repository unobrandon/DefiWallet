//
//  NotificationBanner.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 3/5/22.
//

import SwiftUI
import UserNotifications

struct NotificationBanner: View {

    @State private var lockedOutText: String = ""
    @State private var toggleOn = false
    private let style: AppStyle
    private let onSuccess: () -> Void

    init(style: AppStyle, onSuccess: @escaping () -> Void) {
        self.style = style
        self.onSuccess = onSuccess
    }

    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            Image(systemName: "bell.badge")
                .resizable()
                .frame(width: 25, height: 25, alignment: .center)
                .font(Font.title.weight(.medium))
                .foregroundColor(Color.primary)
                .padding(.horizontal, 20)

            VStack(alignment: .leading, spacing: 5) {
                Text("Push Notifications")
                    .fontTemplate(DefaultTemplate.bodyBold)

                Text("Receive alerts and more")
                    .fontTemplate(DefaultTemplate.caption)
                    .lineLimit(1)
            }
            .padding(.vertical)

            Spacer()
            Toggle("", isOn: $toggleOn)
                .labelsHidden()
                .padding(.trailing, 20)
                .onChange(of: toggleOn) { _ in
                    guard toggleOn else { return }

                    askNotifications()

                    #if os(iOS)
                        HapticFeedback.rigidHapticFeedback()
                    #endif
                }
        }
        .frame(maxWidth: Constants.iPadMaxWidth)
        .overlay(RoundedRectangle(cornerRadius: 10, style: .circular)
                    .stroke(DefaultTemplate.borderColor.opacity(style == .border ? 1.0 : 0.0), lineWidth: 2)
                    .foregroundColor(style == .border ? Color.clear : Color("baseButton")))
        .shadow(color: Color.black.opacity(style == .shadow ? 0.15 : 0.0), radius: 15, x: 0, y: 8)
        .padding(.horizontal, 2)
        .padding(.horizontal)
    }

    private func askNotifications() {
        #if os(iOS)
        if #available(iOS 10, *) {
            UserNotifications.UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound, .carPlay], completionHandler: { (_, error) in
                if error == nil {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })

                    onSuccess()
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
            DispatchQueue.main.async(execute: {
                UIApplication.shared.registerUserNotificationSettings(notificationSettings)
                UIApplication.shared.registerForRemoteNotifications()
            })

            onSuccess()
        }
        #else
        onSuccess()
        #endif
    }

}
