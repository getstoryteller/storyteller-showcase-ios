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
        // Do any additional setup after loading the view.
        
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            scrollView.refreshControl = refresher
        } else {
            print("\(String(describing: self)) - pull to refresh not supported, reason: iOS 10 or above required")
        }
        
        storytellerRowView.delegate = self
        storytellerRowView.cellType = StorytellerRowViewCellType.Square.rawValue
    }
    
    @objc func onPullToRefresh() {
        storytellerRowView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Storyteller.sharedInstance.initialize(apiKey: "<apiKey>")
        Storyteller.sharedInstance.setUserDetails(userInput: UserInput(externalId: "user-id"), onComplete: {
            self.storytellerRowView.reloadData()
        }) { error in
            // Handle error
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storytellerRowView.reloadData()
    }
    
    func onStoriesDataLoadStarted() {
        NSLog("onStoriesDataLoadStarted")
    }

    func onStoriesDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        NSLog("onStoriesDataLoadStarted - sucess: \(success), error: \(error), dataCount: \(dataCount).")

        DispatchQueue.main.async {
            self.refresher?.endRefreshing()
        }
    }

    func onStoryDismissed() {
        NSLog("onStoryDismissed")
    }

    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        NSLog("onUserActivityOccurred - type: \(type), data: \(data).")
    }

    func userSwipedUpToApp(swipeUpUrl: String) {
        NSLog("userSwipedUpToApp")
    }
}

