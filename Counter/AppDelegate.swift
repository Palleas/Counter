//
//  AppDelegate.swift
//  YouCanDoIt
//
//  Created by POUCLET, Romain (MTL) on 2017-01-31.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = CounterViewController()
        window.makeKeyAndVisible()

        let s = Synchronizer(counter: Counter())
        s.synchronize().startWithResult { print("Result = \($0)") }

        self.window = window

        return true
    }

}

