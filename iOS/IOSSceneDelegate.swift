//
//  IOSSceneDelegate.swift
//  DefiWallet (iOS)
//
//  Created by Brandon Shaw on 7/27/22.
//

import SwiftUI
import LocalAuthentication

class IOSSceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        let contentView = MainCoordinator().view()

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        //print("scene did disconnect")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead)
    }

    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if let incomingURL = userActivity.webpageURL {
//            DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL, completion: { (dynamicLink, error) in
//                guard error == nil else { return }
//
//                if let dynamicLink = dynamicLink {
//                    self.environment.handleIncomingDynamicLink(dynamicLink)
//                }
//            })
        }
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
//        print("scene did become active")
//        if self.environment.isUserAuthenticated == .signedIn {
//            self.auth.contacts.updateContacts(contactList: Chat.instance.contactList?.contacts ?? [], completion: { _ in })
//            self.auth.contacts.observeQuickSnaps()
//            self.auth.profile.observeFirebaseUser()
//            ChatrApp.connect()
//            self.auth.dialogs.fetchDialogs(completion: { _ in
//                self.auth.contacts.observeQuickSnaps()
//                self.auth.profile.observeFirebaseUser()
//                self.environment.initIAPurchase()
//            })
//        }
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
//        print("scene will resign active")
//        if self.environment.isUserAuthenticated == .signedIn {
//            if self.environment.profile.results.first?.isLocalAuthOn ?? false {
//                self.environment.isLoacalAuth = true
//            }
//            if let dialog = self.environment.selectedConnectyDialog {
//                dialog.sendUserStoppedTyping()
//            }
//        } else {
//            UIApplication.shared.applicationIconBadgeNumber = 0
//        }
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
//        print("scene will enter foreground \(Thread.isMainThread)")
        
        StoreReviewHelper.incrementAppOpenedCount()
        StoreReviewHelper.checkAndAskForReview()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
//        print("scene did enter background")
//        if self.environment.isUserAuthenticated == .signedIn {
//            if let dialog = self.environment.selectedConnectyDialog {
//                dialog.sendUserStoppedTyping()
//            }
//
//            self.badgeNum = 0
//            for dia in self.environment.dialogs.results.filter({ $0.isDeleted != true }) {
//                badgeNum += dia.notificationCount
//            }
//            UIApplication.shared.applicationIconBadgeNumber = badgeNum + (self.environment.profile.results.first?.contactRequests.count ?? 0)
//
//            //This causes a crash for some reason...not anymore because of print
//            Chat.instance.disconnect { _ in }
//        }
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    private func sendLocalAuth() {
//        guard self.environment.profile.results.first?.isLocalAuthOn == true else { return }

        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                DispatchQueue.main.async {
                    if success {
//                        self.environment.isLoacalAuth = false
                    }
                }
            }
        }
    }
}
