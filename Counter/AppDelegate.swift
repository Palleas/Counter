//
//  AppDelegate.swift
//  YouCanDoIt
//
//  Created by POUCLET, Romain (MTL) on 2017-01-31.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = CounterViewController()
        window.makeKeyAndVisible()

        self.window = window

        return true
    }

}

