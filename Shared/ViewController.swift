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

    @IBAction func changeUserTapped() {
        setRandomUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Storyteller.sharedInstance.initialize(apiKey: "<apiKey>", onComplete: {
            Storyteller.sharedInstance.setUserDetails(userInput: UserInput(externalId: "user-id"))
            self.storytellerRowView.reloadData()
        }) { error in
            // Handle error
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        storytellerRowView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDeeplinkPreview",
           let controller = segue.destination as? DeeplinkPreviewController,
           let url = sender as? String {
            controller.deeplinkUrl = url
        }
    }
  
    private func setRandomUser() {
        // If you use login in your app and wish to allow users to logout and log back in as a new user
        // (or proceed as an anonymous user) then when a user logs out you should call setUserDetails
        // again specifying a new externalId. Note that this will reset the local store of which pages the user has viewed.
        // For more info, see - https://docs.getstoryteller.com/documents/ios-sdk/Users
        let newIdentifier = UUID().uuidString
        Storyteller.sharedInstance.setUserDetails(userInput: UserInput(externalId: newIdentifier))
        self.storytellerRowView.reloadData()

        showAlert(message: "New user with ID: \(newIdentifier).")
    }

    private func showAlert(message: String) {
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)

        present(controller, animated: true, completion: nil)
    }

  
    // MARK: - StorytellerRowViewDelegate methods    
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
        // Open another module in the app and pass given url as param.
        storytellerRowView.dismissStoryView(animated: true, dismissReason: nil) {
            self.performSegue(withIdentifier: "showDeeplinkPreview", sender: swipeUpUrl)
        }
    }

    func tileBecameVisible(index: Int) {
        NSLog("tileBecameVisible: \(index)")
    }
}

