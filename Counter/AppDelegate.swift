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

            let keyPathExpression = NSExpression(forKeyPath: "timestamp")

            let expression = NSExpression(forConstantValue: <#T##Any?#>)
//            let expression = NSExpression(block: { object, objects, _ in
//                guard let object = object as? NSDate else { return 0 }
//
//                print("Evaluated object = \(object)")
//
//                return 1
//            }, arguments: [keyPathExpression])

            let desc = NSExpressionDescription()
            desc.name = "number_of_week"
            desc.expression = expression
            desc.expressionResultType = .integer16AttributeType

            let f = NSFetchRequest<NSFetchRequestResult>(entityName: "Synchronization")
            f.propertiesToFetch = [desc]
            f.resultType = .dictionaryResultType
            f.sortDescriptors = [NSSortDescriptor(key: "number_of_week", ascending: true)]
            let results = try! c.viewContext.fetch(f)


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

