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

        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        let c = NSPersistentContainer(name: "Model")
        c.loadPersistentStores { _, error in
            if let error = error {
                print("Got error = \(error)")
                return
            }

//            let e = NSExpression(block: <#T##(Any?, [Any], NSMutableDictionary?) -> Any#>, arguments: <#T##[NSExpression]?#>)
            let f = NSFetchRequest<Synchronization>(entityName: "Synchronization")
            f.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
            let results = try! c.viewContext.fetch(f) as [Synchronization]


            print("Results = \(results)")
        }


        self.window = window

        return true
    }

    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let s = Synchronizer(counter: Counter())
        s.synchronize().startWithResult { result in
            print("Result = \(result)")
            switch result {
            case .success(_):
                completionHandler(.newData)
            case .failure(_):
                completionHandler(.failed)
            }
        }

    }

}

