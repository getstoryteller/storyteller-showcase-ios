//
//  HomeController.swift
//  StorytellerSampleApp
//
//  Created by Bartosz Stelmaszuk on 04/07/2022.
//  Copyright © 2022 Storm Ideas. All rights reserved.
//

import Foundation
import UIKit
import StorytellerSDK

class HomeController: UIViewController {
    
    @IBOutlet weak var home: StorytellerHomeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home.homeId = "<homeId>"
        home.reloadData()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
