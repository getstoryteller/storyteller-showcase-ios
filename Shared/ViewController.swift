//
//  ViewController.swift
//  StorytellerSampleApp
//
//  Created by Jason Xie on 11/02/2020.
//  Copyright © 2020 Storm Ideas. All rights reserved.
//

import UIKit
import StorytellerSDK

class ViewController: UIViewController, StorytellerListViewDelegate, StorytellerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storytellerRowView: StorytellerRowView!
    @IBOutlet weak var storytellerGridView: StorytellerGridView!
    
    var refresher: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refresher = UIRefreshControl()
        refresher?.addTarget(self, action: #selector(onPullToRefresh), for: .valueChanged)
        scrollView.refreshControl = refresher
        
        // Set current class for StorytellerDelegate.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#HowToUse
        Storyteller.sharedInstance.delegate = self
              
        // Set current class for StorytellerListViewDelegates.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#HowToUse
        storytellerRowView.delegate = self
        storytellerGridView.delegate = self

        // Set thumbnail shape.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view#Attributes
        storytellerRowView.cellType = StorytellerListViewCellType.square.rawValue
    }
    
    @objc func onPullToRefresh() {
        storytellerRowView.reloadData()
        storytellerGridView.reloadData()
    }

    @IBAction func changeUserTapped() {
        setRandomUser()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // SDK initialization requires providing api key.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/getting-started#SDKInitialization
        Storyteller.sharedInstance.initialize(apiKey: "<apiKey>", userInput: UserInput(externalId: "user-id"), onComplete: {
            // Reload data with the params set above.
            // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view#Methods
            self.storytellerRowView.reloadData()
            self.storytellerGridView.reloadData()
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
        // (or proceed as an anonymous user) then when a user logs out you should initialize SDK
        // again specifying a new externalId. Note that this will reset the local store of which pages the user has viewed.
        // For more info, see - https://www.getstoryteller.com/documentation/ios/users
        let newIdentifier = UUID().uuidString
        
        // SDK initialization requires providing api key.
        // For more info, see: https://www.getstoryteller.com/documentation/ios/getting-started#SDKInitialization
        Storyteller.sharedInstance.initialize(apiKey: "<apiKey>", userInput: UserInput(externalId: newIdentifier), onComplete: {
            // Reload data with the params set above.
            // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view#Methods
            self.storytellerRowView.reloadData()
            self.storytellerGridView.reloadData()
        }) { error in
            // Handle error
        }

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
  
    // Called when the network request to load data for all stories has started.
    func onStoriesDataLoadStarted() {
        NSLog("onStoriesDataLoadStarted")
    }

    // Called when data loading is finished.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#ErrorHandling
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
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#Analytics
    func onUserActivityOccurred(type: UserActivity.EventType, data: UserActivityData) {
        NSLog("onUserActivityOccurred - type: \(type), data: \(data).")
    }

    // Called when user swipes up on story's page.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#SwipingUpToTheIntegratingApp
    func userSwipedUpToApp(swipeUpUrl: String) {
        // Open another module in the app and pass given url as param.
        Storyteller.dismissStoryView(animated: true, dismissReason: nil) {
            self.performSegue(withIdentifier: "showDeeplinkPreview", sender: swipeUpUrl)
        }
    }

    // Called when tile with given index becomes visible.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-list-view-delegate#TileVisibility
    func tileBecameVisible(index: Int) {
        NSLog("tileBecameVisible: \(index)")
    }

    // Called when tenant is configured to use ads from the containing app.
    // For more info, see: https://www.getstoryteller.com/documentation/ios/storyteller-delegate#ClientAds
    func getAdsForRow(stories: [ClientStory], onComplete: @escaping ([ClientAd?]) -> Void, onError: @escaping (Error) -> Void) {
        onComplete([])
    }
}

