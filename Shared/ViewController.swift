//
//  ViewController.swift
//  StorytellerSampleApp
//
//  Created by Jason Xie on 11/02/2020.
//  Copyright © 2020 Storm Ideas. All rights reserved.
//

import UIKit
import StorytellerSDK

class ViewController: UIViewController, StorytellerRowViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storytellerRowView: StorytellerRowView!
    
    var refresher: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refresher
        } else {
            print("\(String(describing: self)) - pull to refresh not supported, reason: iOS 10 or above required")
        }

        // Set current class as Storyteller delegate.
        storytellerRowView.delegate = self

        // Set thumbnail shape.
        // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowView#storytellerrowviewcelltype
        storytellerRowView.cellType = StorytellerRowViewCellType.Square.rawValue
    }
    
    @objc func onPullToRefresh() {
        storytellerRowView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // SDK initialization requires providing api key.
        // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/GettingStarted#sdk-initialization
        Storyteller.sharedInstance.initialize(apiKey: "<apiKey>", onComplete: {

            // Authenticate a user by setting details containing an UUID.
            // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/Users
            Storyteller.sharedInstance.setUserDetails(userInput: UserInput(externalId: "user-id"))

            // Reload data with the params set above.
            // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowView#reloaddata
            self.storytellerRowView.reloadData()
        }) { error in
            // Handle error
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        storytellerRowView.reloadData()
    }

    // MARK: - StorytellerRowViewDelegate methods

    // Called when the network request to load data for all stories has started.
    func onStoriesDataLoadStarted() {
        NSLog("onStoriesDataLoadStarted")
    }

    // Called when data loading is finished.
    // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowViewDelegate#error-handling
    func onStoriesDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        NSLog("onStoriesDataLoadStarted - sucess: \(success), error: \(error), dataCount: \(dataCount).")

        DispatchQueue.main.async {
            self.refresher?.endRefreshing()
        }
    }

    // Called when any story has been dismissed.
    func onStoryDismissed() {
        NSLog("onStoryDismissed")
    }

    // Called when analytics event occurs.
    // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowViewDelegate#analytics
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        NSLog("onUserActivityOccurred - type: \(type), data: \(data).")
    }

    // Called when user swipes up on story's page.
    // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowViewDelegate#swiping-up-to-the-integrating-app
    func userSwipedUpToApp(swipeUpUrl: String) {
        NSLog("userSwipedUpToApp")
    }

    // Called when tile with given index becomes visible.
    // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowViewDelegate#tile-visibility
    func tileBecameVisible(index: Int) {
        NSLog("tileBecameVisible: \(index)")
    }

    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://docs.getstoryteller.com/documents/ios-sdk/StorytellerRowViewDelegate#client-ads
    func getAdsForRow(stories: [ClientStory], onComplete: @escaping ([ClientAd?]) -> Void, onError: @escaping (Error) -> Void) {
        onComplete([])
    }
}

