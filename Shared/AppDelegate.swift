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
    var storytellerRowView: StorytellerRowView?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        
        let mainstoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewcontroller: ViewController = mainstoryboard.instantiateViewController(withIdentifier: "mainViewController") as! ViewController
        window?.rootViewController = newViewcontroller

        storytellerRowView = newViewcontroller.storytellerRowView
        
        return true
    }

    private func handle(url: URL) {
        // If your app needs to open specific story or page e.g. when opening an activity from a deep link,
        // then you should call openStory(storyId) or openPage(pageId).
        // For more info, see - https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowView#openstory-id-string-animated-bool-true-onerror-storytellerrowvie
        let pageId = url.lastPathComponent
        storytellerRowView?.openPage(id: pageId)
    }
}

