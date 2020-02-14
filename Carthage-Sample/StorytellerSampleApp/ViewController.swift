//
//  ViewController.swift
//  StorytellerSampleApp
//
//  Created by Jason Xie on 11/02/2020.
//  Copyright © 2020 Storm Ideas. All rights reserved.
//

import UIKit
import Storyteller

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
    }
    
    @objc func onPullToRefresh() {
        storytellerRowView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storytellerRowView.reloadData()
    }
    
    func onChannelsDataLoadStarted() {
        NSLog("onChannelsDataLoadStarted")
    }
    
    func onChannelsDataLoadComplete(success: Bool, error: Error?, dataCount: Int) {
        NSLog("onChannelsDataLoadComplete success \(success), error \(error), dataCount \(dataCount)")
        refresher?.endRefreshing()
    }
    
    func onChannelDismissed() {
        NSLog("onChannelDismissed")
    }
    
}

