//
//  AppDelegate.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 15.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        initializeWindow()
        return true
    }

    func initializeWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)

        let chatScreen = ChatScreenAssembly.assemble()
        let navigationController = UINavigationController(rootViewController: chatScreen)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}

