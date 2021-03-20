//
//  AppDelegate.swift
//  Kimp
//
//  Created by 김종권 on 2021/03/19.
//

import UIKit
import Domain
import CommonExtension
import RxSwift
import RxCocoa

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let bag = DisposeBag()
    private let keychain = KeychainService.shared
    var postTaskManager = PostTaskManager()
    lazy var router = SplashCoordinator(rootViewController: UINavigationController(), postTaskManager: self.postTaskManager, initialRoute: .splash).strongRouter
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Firebase
//        FirebaseApp.configure() // GoogleService-info.plist파일이 없으면 크래시

        // Keychain
        removeOldKeychainVluesIfNeeded()

        // RouteToSplash
        window = UIWindow(frame: UIScreen.main.bounds)
        routeToSplash()

        return true
    }

    private func removeOldKeychainVluesIfNeeded() {
        guard UserDefaults.isFirstLaunch() else {
            return
        }
        keychain.deleteUserInfo()
    }

    func routeToSplash(tokenExpired: Bool = false) {
        if tokenExpired {
//            _ = try? Auth.auth().signOut()
//            keychain.removeUserCreds()
            self.postTaskManager.removeAll()
        }

        router = SplashCoordinator(rootViewController: UINavigationController(), postTaskManager: self.postTaskManager, initialRoute: .splash).strongRouter
        router.setRoot(for: window!)
        window?.makeKeyAndVisible()
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        DeeplinkManager.processDeeplink(response: response, postTaskManager: postTaskManager)
    }

}
