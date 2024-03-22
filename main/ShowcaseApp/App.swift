import SwiftUI
import StorytellerSDK
import GoogleMobileAds
import Amplitude

class AppViewModel: ObservableObject {
    @ObservedObject var router = Router()
    @ObservedObject var dataService = DataGateway()
    lazy var storytellerService = StorytellerService(dataService: dataService)

    init() {
        Task {
            storytellerService.setup(withDataService: dataService)
        }
    }
    
    func setStorytellerDelegate() {
        storytellerService.setDelegate(router: router)
    }
}

@main
struct ShowcaseApp: App {

    // This showcase application shows how to fetch information about which Stories and Clips content to display
    // from an external API and then how to render these using the Storyteller SDK.
    // The DataGateway class is used to fetch this information from the API.
    
    // We recommend initializing the Storyteller SDK as near as possible to when your app starts.
    // This happens inside the StorytellerService in this sample.

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var phase
    @StateObject var viewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: MainViewModel())
                .environmentObject(viewModel.router)
                .environmentObject(viewModel.dataService)
                .onChange(of: phase, perform: { value in
                    switch value {
                    case .active:
                        viewModel.setStorytellerDelegate()
                    case .inactive, .background:
                        break
                    @unknown default:
                        break
                    }
                })
        }
    }
}

class AppDelegate : NSObject, UIApplicationDelegate {

    // The Storyteller SDK supports displaying Ads from Google Ad Manager.
    // For more information on this please see the code in the Ads folder in this application
    // as well as our public documentation here https://www.getstoryteller.com/documentation/ios/ads

    // The Storyteller SDK supports reporting on user activity to any analytics implementation.
    // In this sample, we show how to do so with Amplitude.
    // For more on this integration, please see the code in the Analytics folder in this application
    // as well as our public documentation here https://www.getstoryteller.com/documentation/ios/analytics
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ GADSimulatorID ]
        
        Amplitude.instance().initializeApiKey(Settings.AmplitudeApiKey)

        return true
    }

    // The methods below have been implemented in order to handle deep links from Storyteller.
    // When users share a Story from Storyteller, they are given a link which should be configured as a Universal Link for your app
    // You can see more details on how to do this in our public documentation here
    // https://www.getstoryteller.com/documentation/ios/deeplinking
    // This methods are then implemented to handle the Universal Link
    // and open the Story or Clips Player at the relevant Story or Clip.
    // Note that Storyteller.openDeepLink returns a bool so you can tell if it handled the deeplink or not.
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Storyteller.openDeepLink(url: url) { error in
            print(error)
        }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL
        else {
            return false
        }
        
        Storyteller.openDeepLink(url: url) { error in
            print(error)
        }
        
        return true
    }
}
