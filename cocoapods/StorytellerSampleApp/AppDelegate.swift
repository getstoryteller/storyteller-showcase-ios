import StorytellerSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        let vc = MainViewController()
        navigationController.pushViewController(vc, animated: false)
        self.window = window

        return true
    }
}

