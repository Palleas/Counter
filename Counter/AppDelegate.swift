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

