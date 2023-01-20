//
//  AppDelegate.swift
//  StorytellerSampleApp
//
//  Created by Jason Xie on 14/02/2020.
//  Copyright © 2020 Storm Ideas. All rights reserved.
//

import UIKit
import StorytellerSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appFlowController: MainFlowController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()

        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        appFlowController = MainFlowController()
        appFlowController?.present(in: navigationController)
        self.window = window
        
        return true
    }
}

