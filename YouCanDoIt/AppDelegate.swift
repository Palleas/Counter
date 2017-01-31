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
        let c = Counter()
        c.count().startWithResult { result in
            switch result {
            case let .success(count): print("Fetched \(count) files")
            case let .failure(error): print("Got error = \(error)")
            }
        }
        return true
    }

}

